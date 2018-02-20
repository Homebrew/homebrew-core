class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats/archive/v6.2.2.tar.gz"
  sha256 "0866c3e26fcbd55f191e746b3bf925b450badd13fb72ea9f712481559932c878"
  head "https://github.com/elastic/beats.git"

  # Patch required to build against go 1.10.
  # May be removed once upstream beats project fully supports go 1.10.
  patch :DATA

  bottle do
    cellar :any_skip_relocation
    sha256 "89a512f7e6483e634d9e26a7cbd999ed2be83e80256589a7cfdce0600d6bc906" => :high_sierra
    sha256 "59588c80d3da694711390d71622d60fe61d235b49b6781f69ce2b75605e1d4d5" => :sierra
    sha256 "55a88b565153a924e528a7ae87384880291bf865f66bc85746fdee6b404ca23d" => :el_capitan
  end

  depends_on "go" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"

    resource("virtualenv").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin"

    cd "src/github.com/elastic/beats/auditbeat" do
      # prevent downloading binary wheels
      inreplace "../libbeat/scripts/Makefile", "pip install", "pip install --no-binary :all"
      system "make"
      system "make", "DEV_OS=darwin", "update"
      (libexec/"bin").install "auditbeat"
      libexec.install "_meta/kibana"

      (etc/"auditbeat").install Dir["auditbeat*.yml"]
      prefix.install_metafiles
    end

    (bin/"auditbeat").write <<~EOS
      #!/bin/sh
        exec #{libexec}/bin/auditbeat \
        -path.config #{etc}/auditbeat \
        -path.data #{var}/lib/auditbeat \
        -path.home #{libexec} \
        -path.logs #{var}/log/auditbeat \
        "$@"
    EOS
  end

  def post_install
    (var/"lib/auditbeat").mkpath
    (var/"log/auditbeat").mkpath
  end

  plist_options :manual => "auditbeat"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/auditbeat</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    (testpath/"files").mkpath
    (testpath/"config/auditbeat.yml").write <<~EOS
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    EOS
    pid = fork do
      exec "#{bin}/auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5

    begin
      touch testpath/"files/touch"
      sleep 30
      s = IO.readlines(testpath/"auditbeat/auditbeat").last(1)[0]
      assert_match "\"action\":\[\"created\"\]", s
      realdirpath = File.realdirpath(testpath)
      assert_match "\"path\":\"#{realdirpath}/files/touch\"", s
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/vendor/github.com/fsnotify/fsevents/wrap.go b/vendor/github.com/fsnotify/fsevents/wrap.go
index 26184ab4c..698aec34a 100644
--- a/vendor/github.com/fsnotify/fsevents/wrap.go
+++ b/vendor/github.com/fsnotify/fsevents/wrap.go
@@ -1,4 +1,4 @@
-// +build darwin
+// +build darwin,go1.10
 
 package fsevents
 
@@ -109,14 +109,14 @@ func GetStreamRefPaths(f FSEventStreamRef) []string {
 // in the FSEvents database
 func GetDeviceUUID(deviceID int32) string {
 	uuid := C.FSEventsCopyUUIDForDevice(C.dev_t(deviceID))
-	if uuid == nil {
+	if uuid == C.CFUUIDRef(0) {
 		return ""
 	}
 	return cfStringToGoString(C.CFUUIDCreateString(nil, uuid))
 }
 
 func cfStringToGoString(cfs C.CFStringRef) string {
-	if cfs == nil {
+	if cfs == 0 {
 		return ""
 	}
 	cfStr := C.CFStringCreateCopy(nil, cfs)
@@ -173,7 +173,7 @@ func createPaths(paths []string) (C.CFArrayRef, error) {
 		defer C.free(unsafe.Pointer(cpath))
 
 		str := C.CFStringCreateWithCString(nil, cpath, C.kCFStringEncodingUTF8)
-		C.CFArrayAppendValue(cPaths, unsafe.Pointer(str))
+		C.CFArrayAppendValue(C.CFMutableArrayRef(cPaths), unsafe.Pointer(str))
 	}
 	var err error
 	if len(errs) > 0 {
@@ -229,7 +229,7 @@ func (es *EventStream) start(paths []string, callbackInfo uintptr) {
 	go func() {
 		runtime.LockOSThread()
 		es.rlref = CFRunLoopRef(C.CFRunLoopGetCurrent())
-		C.FSEventStreamScheduleWithRunLoop(es.stream, es.rlref, C.kCFRunLoopDefaultMode)
+		C.FSEventStreamScheduleWithRunLoop(es.stream, C.CFRunLoopRef(es.rlref), C.kCFRunLoopDefaultMode)
 		C.FSEventStreamStart(es.stream)
 		close(started)
 		C.CFRunLoopRun()
@@ -265,5 +265,5 @@ func stop(stream FSEventStreamRef, rlref CFRunLoopRef) {
 	C.FSEventStreamStop(stream)
 	C.FSEventStreamInvalidate(stream)
 	C.FSEventStreamRelease(stream)
-	C.CFRunLoopStop(rlref)
+	C.CFRunLoopStop(C.CFRunLoopRef(rlref))
 }
diff --git a/vendor/github.com/fsnotify/fsevents/wrap_deprecated.go b/vendor/github.com/fsnotify/fsevents/wrap_deprecated.go
new file mode 100644
index 000000000..5493428bd
--- /dev/null
+++ b/vendor/github.com/fsnotify/fsevents/wrap_deprecated.go
@@ -0,0 +1,276 @@
+// +build darwin,!go1.10
+
+package fsevents
+
+/*
+#cgo LDFLAGS: -framework CoreServices
+#include <CoreServices/CoreServices.h>
+#include <sys/stat.h>
+
+static CFArrayRef ArrayCreateMutable(int len) {
+	return CFArrayCreateMutable(NULL, len, &kCFTypeArrayCallBacks);
+}
+
+extern void fsevtCallback(FSEventStreamRef p0, uintptr_t info, size_t p1, char** p2, FSEventStreamEventFlags* p3, FSEventStreamEventId* p4);
+
+static FSEventStreamRef EventStreamCreateRelativeToDevice(FSEventStreamContext * context, uintptr_t info, dev_t dev, CFArrayRef paths, FSEventStreamEventId since, CFTimeInterval latency, FSEventStreamCreateFlags flags) {
+	context->info = (void*) info;
+	return FSEventStreamCreateRelativeToDevice(NULL, (FSEventStreamCallback) fsevtCallback, context, dev, paths, since, latency, flags);
+}
+
+static FSEventStreamRef EventStreamCreate(FSEventStreamContext * context, uintptr_t info, CFArrayRef paths, FSEventStreamEventId since, CFTimeInterval latency, FSEventStreamCreateFlags flags) {
+	context->info = (void*) info;
+	return FSEventStreamCreate(NULL, (FSEventStreamCallback) fsevtCallback, context, paths, since, latency, flags);
+}
+*/
+import "C"
+import (
+	"fmt"
+	"log"
+	"path/filepath"
+	"reflect"
+	"runtime"
+	"time"
+	"unsafe"
+)
+
+// eventIDSinceNow is a sentinel to begin watching events "since now".
+// NOTE: Go 1.9.2 broke compatibility here, for 1.9.1 and earlier we did:
+//   uint64(C.kFSEventStreamEventIdSinceNow + (1 << 64))
+// But 1.9.2+ complains about overflow and requires:
+//   uint64(C.kFSEventStreamEventIdSinceNow)
+// There does not seem to be an easy way to rectify, so hardcoding the value
+// here from FSEvents.h:
+//   kFSEventStreamEventIdSinceNow = 0xFFFFFFFFFFFFFFFFULL
+const eventIDSinceNow = uint64(0xFFFFFFFFFFFFFFFF)
+
+// LatestEventID returns the most recently generated event ID, system-wide.
+func LatestEventID() uint64 {
+	return uint64(C.FSEventsGetCurrentEventId())
+}
+
+// arguments are released by C at the end of the callback. Ensure copies
+// are made if data is expected to persist beyond this function ending.
+//
+//export fsevtCallback
+func fsevtCallback(stream C.FSEventStreamRef, info uintptr, numEvents C.size_t, cpaths **C.char, cflags *C.FSEventStreamEventFlags, cids *C.FSEventStreamEventId) {
+	l := int(numEvents)
+	events := make([]Event, l)
+
+	es := registry.Get(info)
+	if es == nil {
+		log.Printf("failed to retrieve registry %d", info)
+		return
+	}
+	// These slices are backed by C data. Ensure data is copied out
+	// if it expected to exist outside of this function.
+	paths := (*[1 << 30]*C.char)(unsafe.Pointer(cpaths))[:l:l]
+	ids := (*[1 << 30]C.FSEventStreamEventId)(unsafe.Pointer(cids))[:l:l]
+	flags := (*[1 << 30]C.FSEventStreamEventFlags)(unsafe.Pointer(cflags))[:l:l]
+	for i := range events {
+		events[i] = Event{
+			Path:  C.GoString(paths[i]),
+			Flags: EventFlags(flags[i]),
+			ID:    uint64(ids[i]),
+		}
+		es.EventID = uint64(ids[i])
+	}
+
+	es.Events <- events
+}
+
+// FSEventStreamRef wraps C.FSEventStreamRef
+type FSEventStreamRef C.FSEventStreamRef
+
+// GetStreamRefEventID retrieves the last EventID from the ref
+func GetStreamRefEventID(f FSEventStreamRef) uint64 {
+	return uint64(C.FSEventStreamGetLatestEventId(f))
+}
+
+// GetStreamRefDeviceID retrieves the device ID the stream is watching
+func GetStreamRefDeviceID(f FSEventStreamRef) int32 {
+	return int32(C.FSEventStreamGetDeviceBeingWatched(f))
+}
+
+// GetStreamRefDescription retrieves debugging description information
+// about the StreamRef
+func GetStreamRefDescription(f FSEventStreamRef) string {
+	return cfStringToGoString(C.FSEventStreamCopyDescription(f))
+}
+
+// GetStreamRefPaths returns a copy of the paths being watched by
+// this stream
+func GetStreamRefPaths(f FSEventStreamRef) []string {
+	arr := C.FSEventStreamCopyPathsBeingWatched(f)
+	l := cfArrayLen(arr)
+
+	ss := make([]string, l)
+	for i := range ss {
+		void := C.CFArrayGetValueAtIndex(arr, C.CFIndex(i))
+		ss[i] = cfStringToGoString(C.CFStringRef(void))
+	}
+	return ss
+}
+
+// GetDeviceUUID retrieves the UUID required to identify an EventID
+// in the FSEvents database
+func GetDeviceUUID(deviceID int32) string {
+	uuid := C.FSEventsCopyUUIDForDevice(C.dev_t(deviceID))
+	if uuid == nil {
+		return ""
+	}
+	return cfStringToGoString(C.CFUUIDCreateString(nil, uuid))
+}
+
+func cfStringToGoString(cfs C.CFStringRef) string {
+	if cfs == nil {
+		return ""
+	}
+	cfStr := C.CFStringCreateCopy(nil, cfs)
+	length := C.CFStringGetLength(cfStr)
+	if length == 0 {
+		// short-cut for empty strings
+		return ""
+	}
+	cfRange := C.CFRange{0, length}
+	enc := C.CFStringEncoding(C.kCFStringEncodingUTF8)
+	// first find the buffer size necessary
+	var usedBufLen C.CFIndex
+	if C.CFStringGetBytes(cfStr, cfRange, enc, 0, C.false, nil, 0, &usedBufLen) == 0 {
+		return ""
+	}
+
+	bs := make([]byte, usedBufLen)
+	buf := (*C.UInt8)(unsafe.Pointer(&bs[0]))
+	if C.CFStringGetBytes(cfStr, cfRange, enc, 0, C.false, buf, usedBufLen, nil) == 0 {
+		return ""
+	}
+
+	// Create a string (byte array) backed by C byte array
+	header := (*reflect.SliceHeader)(unsafe.Pointer(&bs))
+	strHeader := &reflect.StringHeader{
+		Data: header.Data,
+		Len:  header.Len,
+	}
+	return *(*string)(unsafe.Pointer(strHeader))
+}
+
+// CFRunLoopRef wraps C.CFRunLoopRef
+type CFRunLoopRef C.CFRunLoopRef
+
+// EventIDForDeviceBeforeTime returns an event ID before a given time.
+func EventIDForDeviceBeforeTime(dev int32, before time.Time) uint64 {
+	tm := C.CFAbsoluteTime(before.Unix())
+	return uint64(C.FSEventsGetLastEventIdForDeviceBeforeTime(C.dev_t(dev), tm))
+}
+
+// createPaths accepts the user defined set of paths and returns FSEvents
+// compatible array of paths
+func createPaths(paths []string) (C.CFArrayRef, error) {
+	cPaths := C.ArrayCreateMutable(C.int(len(paths)))
+	var errs []error
+	for _, path := range paths {
+		p, err := filepath.Abs(path)
+		if err != nil {
+			// hack up some reporting errors, but don't prevent execution
+			// because of them
+			errs = append(errs, err)
+		}
+		cpath := C.CString(p)
+		defer C.free(unsafe.Pointer(cpath))
+
+		str := C.CFStringCreateWithCString(nil, cpath, C.kCFStringEncodingUTF8)
+		C.CFArrayAppendValue(cPaths, unsafe.Pointer(str))
+	}
+	var err error
+	if len(errs) > 0 {
+		err = fmt.Errorf("%q", errs)
+	}
+	return cPaths, err
+}
+
+// CFArrayLen retrieves the length of CFArray type
+// See https://developer.apple.com/library/mac/documentation/CoreFoundation/Reference/CFArrayRef/#//apple_ref/c/func/CFArrayGetCount
+func cfArrayLen(ref C.CFArrayRef) int {
+	// FIXME: this will probably crash on 32bit, untested
+	// requires OS X v10.0
+	return int(C.CFArrayGetCount(ref))
+}
+
+func setupStream(paths []string, flags CreateFlags, callbackInfo uintptr, eventID uint64, latency time.Duration, deviceID int32) FSEventStreamRef {
+	cPaths, err := createPaths(paths)
+	if err != nil {
+		log.Printf("Error creating paths: %s", err)
+	}
+	defer C.CFRelease(C.CFTypeRef(cPaths))
+
+	since := C.FSEventStreamEventId(eventID)
+	context := C.FSEventStreamContext{}
+	info := C.uintptr_t(callbackInfo)
+	cfinv := C.CFTimeInterval(float64(latency) / float64(time.Second))
+
+	var ref C.FSEventStreamRef
+	if deviceID != 0 {
+		ref = C.EventStreamCreateRelativeToDevice(&context, info,
+			C.dev_t(deviceID), cPaths, since, cfinv,
+			C.FSEventStreamCreateFlags(flags))
+	} else {
+		ref = C.EventStreamCreate(&context, info, cPaths, since,
+			cfinv, C.FSEventStreamCreateFlags(flags))
+	}
+
+	return FSEventStreamRef(ref)
+}
+
+func (es *EventStream) start(paths []string, callbackInfo uintptr) {
+
+	since := eventIDSinceNow
+	if es.Resume {
+		since = es.EventID
+	}
+
+	es.stream = setupStream(paths, es.Flags, callbackInfo, since, es.Latency, es.Device)
+
+	started := make(chan struct{})
+
+	go func() {
+		runtime.LockOSThread()
+		es.rlref = CFRunLoopRef(C.CFRunLoopGetCurrent())
+		C.FSEventStreamScheduleWithRunLoop(es.stream, es.rlref, C.kCFRunLoopDefaultMode)
+		C.FSEventStreamStart(es.stream)
+		close(started)
+		C.CFRunLoopRun()
+	}()
+
+	if !es.hasFinalizer {
+		// TODO: There is no guarantee this run before program exit
+		// and could result in panics at exit.
+		runtime.SetFinalizer(es, finalizer)
+		es.hasFinalizer = true
+	}
+
+	<-started
+}
+
+func finalizer(es *EventStream) {
+	// If an EventStream is freed without Stop being called it will
+	// cause a panic. This avoids that, and closes the stream instead.
+	es.Stop()
+}
+
+// flush drains the event stream of undelivered events
+func flush(stream FSEventStreamRef, sync bool) {
+	if sync {
+		C.FSEventStreamFlushSync(stream)
+	} else {
+		C.FSEventStreamFlushAsync(stream)
+	}
+}
+
+// stop requests fsevents stops streaming events
+func stop(stream FSEventStreamRef, rlref CFRunLoopRef) {
+	C.FSEventStreamStop(stream)
+	C.FSEventStreamInvalidate(stream)
+	C.FSEventStreamRelease(stream)
+	C.CFRunLoopStop(rlref)
+}
