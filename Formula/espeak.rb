class Espeak < Formula
  desc "Text to speech, software speech synthesizer"
  homepage "http://espeak.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/espeak/espeak/espeak-1.48/espeak-1.48.04-source.zip"
  sha256 "bf9a17673adffcc28ff7ea18764f06136547e97bbd9edf2ec612f09b207f0659"
  revision 1

  bottle do
    sha256 "f174e6d33f96be4924ecb4b33c764cffdbc2444ea87a626f150dd80a3d2f6765" => :el_capitan
    sha256 "1bb63666e796b5454d53df1004365da2f53f428a6f953fa20fd1bacf909ca61a" => :mavericks
    sha256 "0ed56b0461f6c4c9e859c88d438cdcb8abfad974becb192bb758b7ba6b8fb0b4" => :mountain_lion
    sha256 "2a029aca1a91cf4b2a4cb652f9a3ce6c7a3c9590d5af4aba7038b710ce6d6441" => :lion
  end

  depends_on "portaudio"

  patch :DATA

  def install
    share.install "espeak-data"
    share.install "docs"
    cd "src" do
      rm "portaudio.h"
      system "make", "speak", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      bin.install "speak" => "espeak"
      system "make", "libespeak.a", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      lib.install "libespeak.a" => "libespeak.a"
      system "make", "libespeak.so", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      lib.install "libespeak.so.1.1.48" => "libespeak.dylib"
      system "install_name_tool", "-id", "#{lib}/libespeak.dylib", "#{lib}/libespeak.dylib"
    end
  end

  test do
    system "#{bin}/espeak", "This is a test for Espeak.", "-w", "out.wav"
  end
end
__END__
diff -N -r -u old/src/Makefile new/src/Makefile
--- old/src/Makefile	2014-02-02 17:58:11.000000000 +0700
+++ new/src/Makefile	2016-07-09 22:25:49.000000000 +0700
@@ -16,7 +16,7 @@
 LIBTAG = $(LIB_VERSION).$(RELEASE)
 
 # Use SONAME_OPT=-Wl,h, on Solaris
-SONAME_OPT=-Wl,-soname,
+SONAME_OPT=-Wl,-install_name,
 
 # Use EXTRA_LIBS=-lm on Solaris
 EXTRA_LIBS =
@@ -79,7 +79,7 @@
 	readclause.cpp setlengths.cpp numbers.cpp synth_mbrola.cpp \
 	synthdata.cpp synthesize.cpp translate.cpp mbrowrap.cpp \
 	tr_languages.cpp voices.cpp wavegen.cpp phonemelist.cpp \
-	espeak_command.cpp event.cpp fifo.cpp $(WAVE) debug.cpp klatt.cpp sonic.cpp
+	espeak_command.cpp event.cpp fifo.cpp $(WAVE) debug.cpp klatt.cpp sonic.cpp sem_timedwait.cpp
 
 SRCS1=$(speak_SOURCES)
 OBJS1=$(patsubst %.cpp,%.o,$(SRCS1))
diff -N -r -u old/src/event.cpp new/src/event.cpp
--- old/src/event.cpp	2014-03-04 23:47:15.000000000 +0700
+++ new/src/event.cpp	2016-07-09 22:13:25.000000000 +0700
@@ -35,6 +35,7 @@
 #include <sys/time.h>
 #include <errno.h>
 
+#include "sem_timedwait.h"
 #include "speak_lib.h"
 #include "event.h"
 #include "wave.h"
@@ -93,9 +94,9 @@
   pthread_mutex_init( &my_mutex, (const pthread_mutexattr_t *)NULL);
   init();
 
-  assert(-1 != sem_init(&my_sem_start_is_required, 0, 0));
-  assert(-1 != sem_init(&my_sem_stop_is_required, 0, 0));
-  assert(-1 != sem_init(&my_sem_stop_is_acknowledged, 0, 0));
+  //assert(-1 != sem_init(&my_sem_start_is_required, 0, 0));
+  //assert(-1 != sem_init(&my_sem_stop_is_required, 0, 0));
+  //assert(-1 != sem_init(&my_sem_stop_is_acknowledged, 0, 0));
 
   pthread_attr_t a_attrib;
 
diff -N -r -u old/src/fifo.cpp new/src/fifo.cpp
--- old/src/fifo.cpp	2014-03-04 23:47:15.000000000 +0700
+++ new/src/fifo.cpp	2016-07-09 22:13:25.000000000 +0700
@@ -16,6 +16,7 @@
  *   Free Software Foundation, Inc.,                                       *
  *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
  ***************************************************************************/
+
 #include "speech.h"
 
 #ifdef USE_ASYNC
@@ -23,7 +24,6 @@
 
 
 //<includes
-
 #ifndef PLATFORM_WINDOWS
 #include <unistd.h>
 #endif
@@ -37,6 +37,7 @@
 #include <sys/time.h>
 #include <time.h>
 
+#include "sem_timedwait.h"
 #include "fifo.h"
 #include "wave.h"
 #include "debug.h"
@@ -79,8 +80,8 @@
   pthread_mutex_init( &my_mutex, (const pthread_mutexattr_t *)NULL);
   init(0);
 
-  assert(-1 != sem_init(&my_sem_start_is_required, 0, 0));
-  assert(-1 != sem_init(&my_sem_stop_is_acknowledged, 0, 0));
+  //assert(-1 != sem_init(&my_sem_start_is_required, 0, 0));
+  //assert(-1 != sem_init(&my_sem_stop_is_acknowledged, 0, 0));
 
   pthread_attr_t a_attrib;
   if (pthread_attr_init (& a_attrib)
diff -N -r -u old/src/sem_timedwait.cpp new/src/sem_timedwait.cpp
--- old/src/sem_timedwait.cpp	1970-01-01 07:00:00.000000000 +0700
+++ new/src/sem_timedwait.cpp	2016-07-09 20:10:18.000000000 +0700
@@ -0,0 +1,764 @@
+/*
+ *                       s e m _ t i m e d w a i t
+ *
+ *  Function:
+ *     Implements a version of sem_timedwait().
+ *
+ *  Description:
+ *     Not all systems implement sem_timedwait(), which is a version of
+ *     sem_wait() with a timeout. Mac OS X is one example, at least up to
+ *     and including version 10.6 (Leopard). If such a function is needed,
+ *     this code provides a reasonable implementation, which I think is
+ *     compatible with the standard version, although possibly less
+ *     efficient. It works by creating a thread that interrupts a normal
+ *     sem_wait() call after the specified timeout.
+ *
+ *  Call:
+ *
+ *     The Linux man pages say:
+ *
+ *     #include <semaphore.h>
+ *
+ *     int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout);
+ *
+ *     sem_timedwait() is the same as sem_wait(), except that abs_timeout 
+ *     specifies a limit on the amount of time that the call should block if 
+ *     the decrement cannot be immediately performed. The abs_timeout argument
+ *     points to a structure that specifies an absolute timeout in seconds and
+ *     nanoseconds since the Epoch (00:00:00, 1 January 1970). This structure 
+ *     is defined as follows:
+ *
+ *     struct timespec {
+ *        time_t tv_sec;      Seconds
+ *        long   tv_nsec;     Nanoseconds [0 .. 999999999]
+ *     };
+ *
+ *     If the timeout has already expired by the time of the call, and the 
+ *     semaphore could not be locked immediately, then sem_timedwait() fails 
+ *     with a timeout error (errno set to ETIMEDOUT).
+ *     If the operation can be performed immediately, then sem_timedwait() 
+ *     never fails with a timeout error, regardless of the value of abs_timeout.
+ *     Furthermore, the validity of abs_timeout is not checked in this case.
+ *
+ *  Limitations:
+ *
+ *     The mechanism used involves sending a SIGUSR2 signal to the thread
+ *     calling sem_timedwait(). The handler for this signal is set to a null
+ *     routine which does nothing, and with any flags for the signal 
+ *     (eg SA_RESTART) cleared. Note that this effective disabling of the
+ *     SIGUSR2 signal is a side-effect of using this routine, and means it
+ *     may not be a completely transparent plug-in replacement for a
+ *     'normal' sig_timedwait() call. Since OS X does not declare the
+ *     sem_timedwait() call in its standard include files, the relevant 
+ *     declaration (shown above in the man pages extract) will probably have
+ *     to be added to any code that uses this.
+ *
+ *  Compiling:
+ *     This compiles and runs cleanly on OS X (10.6) with gcc with the
+ *     -Wall -ansi -pedantic flags. On Linux, using -ansi causes a sweep of
+ *     compiler complaints about the timespec structure, but it compiles
+ *     and works fine with just -Wall -pedantic. (Since Linux provides
+ *     sem_timedwait() anyway, this really isn't needed on Linux.) However,
+ *     since Linux provides sem_timedwait anyway, the sem_timedwait()
+ *     code in this file is only compiled on OS X, and is a null on other
+ *     systems.
+ *
+ *  Testing:
+ *     This file contains a test program that exercises the sem_timedwait
+ *     code. It is compiled if the pre-processor variable TEST is defined.
+ *     For more details, see the comments for the test routine at the end
+ *     of the file.
+ *
+ *  Author: Keith Shortridge, AAO.
+ *
+ *  History:
+ *      8th Sep 2009. Original version. KS.
+ *     24th Sep 2009. Added test that the calling thread still exists before
+ *                    trying to set the timed-out flag. KS.
+ *      2nd Oct 2009. No longer restores the original SIGUSR2 signal handler.
+ *                    See comments in the body of the code for more details.
+ *                    Prototypes for now discontinued internal routines removed.
+ *     12th Aug 2010. Added the cleanup handler, so that this code no longer
+ *                    leaks resources if the calling thread is cancelled. KS.
+ *     21st Sep 2011. Added copyright notice below. Modified header comments
+ *                    to describe the use of SIGUSR2 more accurately in the 
+ *                    light of the 2/10/09 change above. Now undefs DEBUG
+ *                    before defining it, to avoid any possible clash. KS.
+ *     14th Feb 2012. Tidied out a number of TABs that had got into the
+ *                    code. KS.
+ *      6th May 2013. Copyright notice modified to one based on the MIT licence,
+ *                    which is more permissive than the previous notice. KS.
+ *
+ *  Copyright (c) Australian Astronomical Observatory (AAO), (2013).
+ *  Permission is hereby granted, free of charge, to any person obtaining a 
+ *  copy of this software and associated documentation files (the "Software"), 
+ *  to deal in the Software without restriction, including without limitation 
+ *  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
+ *  and/or sell copies of the Software, and to permit persons to whom the 
+ *  Software is furnished to do so, subject to the following conditions:
+ *
+ *  The above copyright notice and this permission notice shall be included in 
+ *  all copies or substantial portions of the Software.
+ *
+ *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
+ *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
+ *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
+ *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
+ *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ *  IN THE SOFTWARE.
+ */
+
+#ifdef __APPLE__
+
+#include <semaphore.h>
+#include <time.h>
+#include <sys/time.h>
+#include <pthread.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/fcntl.h>
+#include <setjmp.h>
+
+#include "sem_timedwait.h"
+
+/*  Some useful definitions - TRUE, FALSE, and DEBUG */
+
+#undef TRUE
+#define TRUE 1
+#undef FALSE
+#define FALSE 0
+#undef DEBUG
+#define DEBUG printf
+
+/*  A structure of type timeoutDetails is passed to the thread used to 
+ *  implement the timeout.
+ */
+
+typedef struct {
+   struct timespec delay;            /* Specifies the delay, relative to now */
+   pthread_t callingThread;          /* The thread doing the sem_wait call */
+   volatile short *timedOutShort;    /* Address of a flag set to indicate that
+                                      * the timeout was triggered. */
+} timeoutDetails;
+
+/*  A structure of type cleanupDetails is passed to the thread cleanup 
+ *  routine which is called at the end of the routine or if the thread calling
+ *  it is cancelled.
+ */
+ 
+typedef struct {
+   pthread_t *threadIdAddr;          /* Address of the variable that holds 
+                                      * the Id of the timeout thread. */
+   struct sigaction *sigHandlerAddr; /* Address of the old signal action
+                                      * handler. */
+   volatile short *timedOutShort;    /* Address of a flag set to indicate that
+                                      * the timeout was triggered. */
+} cleanupDetails;
+
+/*  Forward declarations of internal routines */
+
+static void* timeoutThreadMain (void* passedPtr);
+static int triggerSignal (int Signal, pthread_t Thread);
+static void ignoreSignal (int Signal);
+static void timeoutThreadCleanup (void* passedPtr);
+
+/* -------------------------------------------------------------------------- */
+/*
+ *                      s e m _ t i m e d w a i t
+ *
+ *  This is the main code for the sem_timedwait() implementation.
+ */
+
+int sem_timedwait (
+   sem_t *sem,
+   const struct timespec *abs_timeout)
+{
+   int result = 0;                   /* Code returned by this routine 0 or -1 */
+   
+   /*  "Under no circumstances shall the function fail if the semaphore
+    *  can be locked immediately". So we try to get it quickly to see if we
+    *  can avoid all the timeout overheads.
+    */
+   
+   if (sem_trywait(sem) == 0) {
+      
+      /*  Yes, got it immediately. */
+      
+      result = 0;
+      
+   } else {
+      
+      /*  No, we've got to do it with a sem_wait() call and a thread to run
+       *  the timeout. First, work out the time from now to the specified
+       *  timeout, which we will pass to the timeout thread in a way that can
+       *  be used to pass to nanosleep(). So we need this in seconds and
+       *  nanoseconds. Along the way, we check for an invalid passed time,
+       *  and for one that's already expired.
+       */
+      
+      if ((abs_timeout->tv_nsec < 0) || (abs_timeout->tv_nsec > 1000000000)) {
+         
+         /* Passed time is invalid */
+         
+         result = -1;
+         errno = EINVAL;
+         
+      } else {
+         
+         struct timeval currentTime;                              /* Time now */
+         long secsToWait,nsecsToWait;            /* Seconds and nsec to delay */
+         gettimeofday (&currentTime,NULL);
+         secsToWait = abs_timeout->tv_sec - currentTime.tv_sec;
+         nsecsToWait = (abs_timeout->tv_nsec - (currentTime.tv_usec * 1000));
+         while (nsecsToWait < 0) {
+            nsecsToWait += 1000000000;
+            secsToWait--;
+         }
+         if ((secsToWait < 0) || ((secsToWait == 0) && (nsecsToWait < 0))) {
+            
+            /*  Time has passed. Report an immediate timeout. */
+            
+            result = -1;
+            errno = ETIMEDOUT;
+            
+         } else {
+            
+            /*  We're going to have to do a sem_wait() with a timeout thread.
+             *  The thread will wait the specified time, then will issue a
+             *  SIGUSR2 signal that will interrupt the sem_wait() call. 
+             *  We pass the thread the id of the current thread, the delay,
+             *  and the address of a flag to set on a timeout, so we can 
+             *  distinguish an interrupt caused by the timeout thread from
+             *  one caused by some other signal.
+             */
+         
+            volatile short timedOut;                /* Flag to set on timeout */
+            timeoutDetails details;     /* All the stuff the thread must know */
+            struct sigaction oldSignalAction;       /* Current signal setting */
+            pthread_t timeoutThread;                  /* Id of timeout thread */
+            cleanupDetails cleaningDetails; /* What the cleanup routine needs */
+            int oldCancelState;                /* Previous cancellation state */
+            int ignoreCancelState;               /* Used in call, but ignored */
+            int createStatus;              /* Status of pthread_create() call */
+            
+            /*  If the current thread is cancelled (and CML does do this)
+             *  we don't want to leave our timer thread running - if we've
+             *  started the thread we want to make sure we join it in order
+             *  to release its resources. So we set a cleanup handler to
+             *  do this. We pass it the address of the structure that will
+             *  hold all it needs to know. While we set all this up,
+             *  we prevent ourselves being cancelled, so all this data is
+             *  coherent.
+             */
+            
+            pthread_setcancelstate (PTHREAD_CANCEL_DISABLE,&oldCancelState);
+            timeoutThread = (pthread_t) 0;
+            cleaningDetails.timedOutShort = &timedOut;
+            cleaningDetails.threadIdAddr = &timeoutThread;
+            cleaningDetails.sigHandlerAddr = &oldSignalAction;
+            pthread_cleanup_push (timeoutThreadCleanup,&cleaningDetails);
+            
+            /*  Set up the details for the thread. Clear the timeout flag,
+             *  record the current SIGUSR2 action settings so we can restore
+             *  them later.
+             */
+            
+            details.delay.tv_sec = secsToWait;
+            details.delay.tv_nsec = nsecsToWait;
+            details.callingThread = pthread_self();
+            details.timedOutShort = &timedOut;
+            timedOut = FALSE;
+            sigaction (SIGUSR2,NULL,&oldSignalAction);
+            
+            /*  Start up the timeout thread. Once we've done that, we can
+             *  restore the previous cancellation state.
+             */
+            
+            createStatus = pthread_create(&timeoutThread,NULL,
+                                         timeoutThreadMain, (void*)&details);
+            pthread_setcancelstate (oldCancelState,&ignoreCancelState);
+            
+            if (createStatus < 0) {
+               
+               /* Failed to create thread. errno will already be set properly */
+               
+               result = -1;
+               
+            } else {
+               
+               /*  Thread created OK. This is where we wait for the semaphore.
+                */
+               
+               if (sem_wait(sem) == 0) {
+                  
+                  /*  Got the semaphore OK. We return zero, and all's well. */
+                  
+                  result = 0;
+                  
+               } else {
+                  
+                  /*  If we got a -1 error from sem_wait(), it may be because
+                   *  it was interrupted by a timeout, or failed for some
+                   *  other reason. We check for the expected timeout 
+                   *  condition, which is an 'interrupted' status and the
+                   *  timeout flag set by the timeout thread. We report that as
+                   *  a timeout error. Anything else is some other error and
+                   *  errno is already set properly.
+                   */
+                  
+                  result = -1;
+                  if (errno == EINTR) {
+                     if (timedOut) errno = ETIMEDOUT;
+                  }
+               }
+               
+            }
+            
+            /*  The cleanup routine - timeoutThreadCleanup() - packages up
+             *  any tidying up that is needed, including joining with the
+             *  timer thread. This will be called if the current thread is
+             *  cancelled, but we need it to happen anyway, so we set the
+             *  execute flag true here as we remove it from the list of
+             *  cleanup routines to be called. So normally, this line amounts
+             *  to calling timeoutThreadCleanup().
+             */
+             
+            pthread_cleanup_pop (TRUE);
+         }
+      }
+   }
+   return (result);
+}
+
+/* -------------------------------------------------------------------------- */
+/*
+ *                  t i m e o u t  T h r e a d  C l e a n u p
+ *
+ *  This internal routine tidies up at the end of a sem_timedwait() call.
+ *  It is set as a cleanup routine for the current thread (not the timer
+ *  thread) so it is executed even if the thread is cancelled. This is
+ *  important, as we need to tidy up the timeout thread. If we took the
+ *  semaphore (in other words, if we didn't timeout) then the timer thread
+ *  will still be running, sitting in its nanosleep() call, and we need
+ *  to cancel it. If the timer thread did signal a timeout then it will
+ *  now be closing down. In either case, we need to join it (using a call
+ *  to pthread_join()) or its resources will never be released.
+ *  The single argument is a pointer to a cleanupDetails structure that has
+ *  all the routine needs to know.
+ */
+   
+static void timeoutThreadCleanup (void* passedPtr)
+{
+   /*  Get what we need from the structure we've been passed. */
+   
+   cleanupDetails *detailsPtr = (cleanupDetails*) passedPtr;
+   short timedOut = *(detailsPtr->timedOutShort);
+   pthread_t timeoutThread = *(detailsPtr->threadIdAddr);
+   
+   /*  If we created the thread, stop it - doesn't matter if it's no longer
+    *  running, pthread_cancel can handle that. We make sure we wait for it 
+    *  to complete, because it is this pthread_join() call that releases any 
+    *  memory the thread may have allocated. Note that cancelling a thread is 
+    *  generally not a good idea, because of the difficulty of cleaning up 
+    *  after it, but this is a very simple thread that does nothing but call 
+    *  nanosleep(), and that we can cancel quite happily.
+    */
+      
+   if (!timedOut) pthread_cancel(timeoutThread);
+   pthread_join(timeoutThread,NULL);
+   
+   /*  The code originally restored the old action handler, which generally 
+    *  was the default handler that caused the task to exit. Just occasionally,
+    *  there seem to be cases where the signal is still queued and ready to 
+    *  trigger even though the thread that presumably sent it off just before
+    *  it was cancelled has finished. I had thought that once we'd joined
+    *  that thread, we could be sure of not seeing the signal, but that seems 
+    *  not to be the case, and so restoring a handler that will allow the task
+    *  to crash is not a good idea, and so the line below has been commented
+    *  out.
+    *
+    *  sigaction (SIGUSR2,detailsPtr->sigHandlerAddr,NULL);
+    */
+}
+
+/* -------------------------------------------------------------------------- */
+/*
+ *                  t i m e o u t  T h r e a d  M a i n
+ *
+ *  This internal routine is the main code for the timeout thread.
+ *  The single argument is a pointer to a timeoutDetails structure that has
+ *  all the thread needs to know - thread to signal, delay time, and the
+ *  address of a flag to set if it triggers a timeout.
+ */
+   
+static void* timeoutThreadMain (void* passedPtr)
+{
+   void* Return = (void*) 0;
+   
+   /*  We grab all the data held in the calling thread right now. In some
+    *  cases, we find that the calling thread has vanished and released
+    *  its memory, including the details structure, by the time the timeout
+    *  expires, and then we get an access violation when we try to set the
+    *  'timed out' flag.
+    */
+   
+   timeoutDetails details = *((timeoutDetails*) passedPtr);
+   struct timespec requestedDelay = details.delay;
+   
+   /*  We do a nanosleep() for the specified delay, and then trigger a
+    *  timeout. Note that we allow for the case where the nanosleep() is
+    *  interrupted, and restart it for the remaining time. If the 
+    *  thread that is doing the sem_wait() call gets the semaphore, it
+    *  will cancel this thread, which is fine as we aren't doing anything
+    *  other than a sleep and a signal.
+    */
+   
+   for (;;) {
+      struct timespec remainingDelay;
+      if (nanosleep (&requestedDelay,&remainingDelay) == 0) {
+         break;
+      } else if (errno == EINTR) {
+         requestedDelay = remainingDelay;
+      } else {
+         Return = (void*) errno;
+         break;
+      }
+   }
+   
+   /*  We've completed the delay without being cancelled, so we now trigger
+    *  the timeout by sending a signal to the calling thread. And that's it,
+    *  although we set the timeout flag first to indicate that it was us
+    *  that interrupted the sem_wait() call. One precaution: before we
+    *  try to set the timed-out flag, make sure the calling thread still
+    *  exists - this may not be the case if things are closing down a bit
+    *  messily. We check this quickly using a zero test signal.
+    */
+   
+   if (pthread_kill(details.callingThread,0) == 0) {
+      *(details.timedOutShort) = TRUE;
+      if (triggerSignal (SIGUSR2,details.callingThread) < 0) {
+         Return = (void*) errno;
+      }
+   }
+   
+   return Return;
+}
+   
+/* -------------------------------------------------------------------------- */
+/*
+ *                    t r i g g e r  S i g n a l
+ *
+ *  This is a general purpose routine that sends a specified signal to
+ *  a specified thread, setting up a signal handler that does nothing,
+ *  and then giving the signal. The only effect will be to interrupt any
+ *  operation that is currently blocking - in this case, we expect this to
+ *  be a sem_wait() call.
+ */
+   
+static int triggerSignal (int Signal, pthread_t Thread)
+{
+   int Result = 0;
+   struct sigaction SignalDetails;
+   SignalDetails.sa_handler = ignoreSignal;
+   SignalDetails.sa_flags = 0;
+   (void) sigemptyset(&SignalDetails.sa_mask);
+   if ((Result = sigaction(Signal,&SignalDetails,NULL)) == 0) {
+      Result = pthread_kill(Thread,Signal);
+   }
+   return Result;
+}
+   
+/* -------------------------------------------------------------------------- */
+/*
+ *                     i g n o r e  S i g n a l
+ *
+ *  And this is the signal handler that does nothing. (It clears its argument,
+ *  but this has no effect and prevents a compiler warning about an unused
+ *  argument.)
+ */
+    
+static void ignoreSignal (int Signal) {
+   Signal = 0;
+} 
+
+#endif
+
+/* -------------------------------------------------------------------------- */
+/*
+ *                           T e s t  c o d e
+ *
+ *   The rest of the code here is used to test sem_timedwait(), and is 
+ *   compiled only if the pre-processor variable TEST is set. The test
+ *   program sets up a random timeout and a random delay after which a
+ *   test semaphore will become available. It starts a thread to release the
+ *   semaphore after the specified delay, and issues a sem_timedwait() call
+ *   to take the semaphore, with the specified timeout. It repeats this 
+ *   several times, and finally reports the number of times the semaphore 
+ *   was taken, the number of times it timed out, and the number of these
+ *   occurrences that were unexpected - ie a semaphore being taken although
+ *   the timeout was less than the delay before it was set, or vice versa.
+ *   The main() routine of the test returns the number of unexpected
+ *   occurrences, which will be zero if the code is working properly.
+ *
+ *   To run:
+ *   
+ *   gcc -o timed -Wall -ansi -pedantic -DTEST sem_timedwait.c -lpthread
+ *   ./timed [count] [timescale]
+ *
+ *   On some Linux systems, you may need to drop the -ansi - see comments
+ *   at start of file. On OS X systems, most tests up to a time frame of
+ *   0.001 secs show nothing happening in an unexpected sequence. On a
+ *   Linux 2.4 system, with its lower time resolution, tests will show
+ *   occasional cases where things don't happen in the expected order, but
+ *   these are not counted as unexpected if the two random times are less
+ *   than 10 msec apart. 
+ */
+
+#ifdef TEST
+
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+
+/*  A giverDetails structure is used to pass the necessary information
+ *  to the thread that is started to release the semaphore.
+ */
+
+typedef struct {
+   sem_t *semAddr;                        /*  Address of semaphore to release */
+   float delaySecs;                            /* Time to wait before release */
+} giverDetails;
+
+/* -------------------------------------------------------------------------- */
+/*
+ *                           g i v e r  T h r e a d  M a i n
+ *
+ *  This is the main code for the thread that releases the semaphore after
+ *  a specified delay. The single argument is the address of a giverDetails
+ *  structure, which specifies the delay time and the semaphore to release.
+ *  If the sem_timedwait() call in the main thread times-out, this thread
+ *  is cancelled and so will not release the semaphore.
+ */
+
+static void* giverThreadMain (void* passedPtr)
+{
+   /*  All we do is sleep the specified time and then release the semaphore */
+   
+   giverDetails *details = (giverDetails*) passedPtr;
+   long uSecs = (long)(details->delaySecs * 1000000.0);
+   usleep (uSecs);
+   if (sem_post(details->semAddr) < 0) {
+      perror ("sem_post");
+   }
+   return NULL;
+}
+   
+/* -------------------------------------------------------------------------- */
+/*
+ *                                 m a i n
+ *
+ *   The main test routine. This creates a semaphore, then sets up a series
+ *   of sem_timedwait() calls on it. For each call it starts a thread that 
+ *   will release the semaphore after a random time, and specifies another
+ *   similar random time as the timeout for the sem_timedwait() call. It 
+ *   then checks that what happens is what it expects.
+ *
+ *   The pogram takes two optional arguments. The first is an integer giving
+ *   the nuber of sem_timedwait() calls it is to attempt (default 10) and the
+ *   second is a floatig point value that gives the time scale - it is the
+ *   maximum time in seconds for the two random times that are generated for
+ *   each sem_timedwait() call. The times should be fairly evenly distributed
+ *   between this value and a hard-coded minimum of 0.001 seconds. The default
+ *   time scale is 1.0.
+ *
+ *   Note that on all systems, if the difference between the two random times
+ *   (the timeout and the delay before the semaphore is given) is comparable 
+ *   with the scheduling resolution of the system - which is only 10 
+ *   milliseconds on a standard Linux 2.4 kernel - you can expect to get
+ *   some cases where the 'wrong' timer goes off first. So these cases are
+ *   logged, but anything with a difference of less than 10 msec isn't
+ *   included in the unexpected count.
+ */
+
+int main (
+   int argc,
+   char* argv[])
+{
+   char semName[1024];           /* Semaphore name if we need to use sem_open */
+   sem_t theSem;                                      /* The semaphore itself */
+   sem_t *semAddr;                            /* The address of the semaphore */
+   struct timespec absTime;              /* Absolute time at which we timeout */
+   struct timeval currentTime;                          /* The time right now */
+   pthread_t giverThread;          /* Id for the thread that releases the sem */
+   giverDetails details;                /* Details passed to the giver thread */
+   int randomShort;                        /* Random number in range 0..65535 */
+   float randomDelaySecs;              /* Random delay before semaphore given */
+   float randomTimeoutSecs;                           /* Random timeout value */
+   int intSecs;                                  /* Integer number of seconds */
+   long intNsecs;                                /* Nanoseconds in delay time */
+   int msecs;                           /* Milliseconds between the two times */
+   short retry;                                   /* Controls the EAGAIN loop */
+   int count;                      /* Number of tries at the semaphore so far */
+   int takenCount = 0;              /* Number ot time the semaphore was taken */
+   int unexpectedCount = 0;               /* Number of unexpected occurrences */
+   int timeoutCount = 0;                      /* Number of times we timed out */
+   float timeScaleSecs = 1.0;               /* Time scale - from command line */
+   int maxCount = 10;      /* Times through the test loop - from command line */
+   
+   /*  Get the command line arguments, the number of tries, and the time
+    *  scale to use.
+    */
+   
+   if (argc >= 3) {
+      timeScaleSecs = atof(argv[2]);
+   }
+   if (argc >= 2) {
+      maxCount = atoi(argv[1]);
+   }
+   
+   /*  Creating a semaphore is awkward - some systems support sem_init(),
+    *  which is nice, but OS X only supports sem_open() and returns ENOSYS
+    *  for sem_init(). This code handles both cases. The semaphore is
+    *  created taken.
+    */
+   
+   semName[0] = '\0';
+   semAddr = &theSem;
+   if (sem_init(semAddr,0,0) < 0) {
+      if (errno == ENOSYS) {
+         sprintf (semName,"/tmp/test_%ld.sem",(long)getpid());
+         if ((semAddr = sem_open(semName,
+                             O_CREAT|O_EXCL,S_IWUSR | S_IRUSR,0))
+                                                == (sem_t*)SEM_FAILED) {
+            perror ("creating semaphore");
+         }
+      }
+   }
+   
+   /*  Loop through the specified number of tests. */
+   
+   for (count = 0; count < maxCount; count++) {
+      
+      /*  Generate random times for the timeout and for the delay before
+       *  the semaphore is given. I'm only using the last 16 bits from random()
+       *  becasuse that's good enough for this and saves me worrying about
+       *  handling really big integers near the 32 bit limit. First for the
+       *  delay used by the giver thread.
+       */
+      
+      randomShort = random() & 0xffff;
+      randomDelaySecs = ((float)randomShort)/65536.0 * timeScaleSecs;
+      if (randomDelaySecs < 0.001) randomDelaySecs = 0.001;
+      details.semAddr = semAddr;
+      details.delaySecs = randomDelaySecs;
+      
+      /*  And now for the timeout, which has to be converted into an absolute
+       *  time from now in the form required by sem_timedwait.
+       */
+      
+      randomShort = random() & 0xffff;
+      randomTimeoutSecs = ((float)randomShort)/65536.0 * timeScaleSecs;
+      if (randomTimeoutSecs < 0.001) randomTimeoutSecs = 0.001;
+      intSecs = (int)randomTimeoutSecs;
+      intNsecs = (long)((randomTimeoutSecs - (float)intSecs) * 1000000000.0);
+      gettimeofday (&currentTime,NULL);
+      absTime.tv_sec = currentTime.tv_sec + intSecs;
+      absTime.tv_nsec = (currentTime.tv_usec * 1000) + intNsecs;
+      while (absTime.tv_nsec > 1000000000) {
+         absTime.tv_sec++;
+         absTime.tv_nsec -= 1000000000;
+      }
+      
+      /*  Create the 'giver' thread, which will release the semaphore after
+       *  the specified delay time.
+       */
+      
+      pthread_create(&giverThread,NULL,giverThreadMain,(void*)&details);
+      
+      /*  Now try to take the semaphore and see what happens - timeout or
+       *  a taken semaphore? The retry loop handles any cases where an
+       *  EAGAIN problem is signalled.
+       */
+      
+      retry = TRUE;
+      while (retry) {
+         retry = FALSE;
+         if (sem_timedwait (semAddr,&absTime) == 0) {
+            
+            /*  We got the semaphore. See if we expected to. */
+            
+            takenCount++;
+            if (randomDelaySecs > randomTimeoutSecs) {
+               msecs = (int)((randomDelaySecs - randomTimeoutSecs) * 1000.0);
+               printf (
+                  "Sem taken first, delay %f timeout %f, diff %d msec\n",
+                                      randomDelaySecs,randomTimeoutSecs,msecs);
+               if (msecs < 10) {
+                  printf ("Time difference too short to count as an error\n");
+               } else {
+                  unexpectedCount++;
+               }
+            }
+         } else {
+            
+            /*  We failed. See if this was a timeout, in which case see if
+             *  it was expected. If not, check for EAGAIN and retry, or log
+             *  an error in all other cases.
+             */
+            
+            if (errno != ETIMEDOUT) {
+               if (errno == EAGAIN) {
+                  retry = TRUE;
+               } else {
+                  perror ("Timed wait");
+               }
+            } else {
+               timeoutCount++;
+               if (randomDelaySecs < randomTimeoutSecs) {
+                  msecs = (int)((randomTimeoutSecs - randomDelaySecs) * 1000.0);
+                  printf (
+                     "Timedout first, delay %f timeout %f, diff %d msec\n",
+                                     randomDelaySecs,randomTimeoutSecs,msecs);
+                  if (msecs < 10) {
+                     printf (
+                          "Time difference too short to count as an error\n");
+                  } else {
+                     unexpectedCount++;
+                  }
+               }
+            }
+         }
+      }
+      
+      /*  Cancel the giver thread if it's still running (ie a timeout or other
+       *  error), and wait for it to complete - that's needed to release its
+       *  resources.
+       */
+      
+      pthread_cancel(giverThread);
+      pthread_join(giverThread,NULL);
+      
+      /*  Something to show we're still running. */
+      
+      if (((count + 1) % 25) == 0) {
+         printf ("Tries: %d, Taken %d, Timedout %d, unexpected %d\n",
+                           count + 1,takenCount, timeoutCount,unexpectedCount);
+      }
+      
+      /*  And then back to try again. Note that the semaphore shuld now be
+       *  taken. Either it was releaed by the giver and we took it in the
+       *  sem_timedwait() call, or we timed out, in which case it's still
+       *  taken. So the next sem_timedwait() call will wait, just like this
+       *  one.
+       */
+   }
+   printf ("Final results: Taken %d, Timedout %d, unexpected %d\n",
+                                    takenCount,timeoutCount,unexpectedCount);
+   return unexpectedCount;
+}
+
+#endif
diff -N -r -u old/src/sem_timedwait.h new/src/sem_timedwait.h
--- old/src/sem_timedwait.h	1970-01-01 07:00:00.000000000 +0700
+++ new/src/sem_timedwait.h	2016-07-09 21:54:52.000000000 +0700
@@ -0,0 +1 @@
+int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout);
