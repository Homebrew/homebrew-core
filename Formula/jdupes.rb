class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "945b69f1570d058b70c40d144c5dfa9d5769f43e9488e8ac4f47bbb9ac973df7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e24324ee039ffdd10282311adb902056e7d77cc253225b2da32da4e98fa869fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8385586fa874ee9821970e3e8673d5075d068d5b6f46fbd5378a9ac9d755895a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b19421ee595a1c69cf7754a1668f017284835b60c917616f1f3b7e86150a66b8"
    sha256 cellar: :any_skip_relocation, ventura:        "7cf8bcafe29ab0bc5bd9ad959e79d9bf6f46077b9236b22b3e03a684944ad265"
    sha256 cellar: :any_skip_relocation, monterey:       "9d78e219df00b25776c1613c92526a1f3c44df4b1bb1fdebe67e65fa7df00279"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d74756fceec7d480e91d3f7d3b38946d3c945b0b7c101f9584ed32cf2b28bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df5e09093977d45b08da78175dd18e8f221734d34c95cca11be1fec6beca13d"
  end

  resource "libjodycode" do
    url "https://github.com/jbruchon/libjodycode/archive/refs/tags/v1.0.tar.gz"
    sha256 "3849c7a76c46687eafcff8db37477ce31662ac7a0d88cbd7495755b0f9859280"

    patch :DATA
  end

  def install
    resource("libjodycode").stage do
      system "make", "install", "PREFIX=#{libexec}/libjodycode"
    end
    ENV.append "CFLAGS", "-I#{libexec}/libjodycode/include"
    extra_rpath = rpath(target: libexec/"libjodycode/lib").gsub("$", "\\$$")
    ENV.append "LDFLAGS", "-L#{libexec}/libjodycode/lib -Wl,-rpath,#{extra_rpath}"
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end

__END__
--- a/Makefile
+++ b/Makefile
@@ -23,8 +23,13 @@ COMPILER_OPTIONS += -Wshadow -Wfloat-equal -Waggregate-return -Wcast-qual -Wswit
 COMPILER_OPTIONS += -std=gnu99 -D_FILE_OFFSET_BITS=64 -fstrict-aliasing -pipe -fPIC
 
 UNAME_S=$(shell uname -s)
-VERSION=$(shell grep '#define VER ' version.h | sed 's/[^"]*"//;s/".*//')
-VERSION_MAJOR=$(shell grep '#define VER ' version.h | sed 's/[^"]*"//;s/\..*//')
+VERSION=$(shell grep '\#define VER ' version.h | sed 's/[^"]*"//;s/".*//')
+VERSION_MAJOR=$(shell grep '\#define VER ' version.h | sed 's/[^"]*"//;s/\..*//')
+
+# Shared libraries on macOS use .dylib extension
+ifeq ($(UNAME_S), Darwin)
+	SUFFIX = dylib
+endif
 
 # Don't use unsupported compiler options on gcc 3/4 (Mac OS X 10.5.8 Xcode)
 ifeq ($(UNAME_S), Darwin)
@@ -96,27 +101,28 @@ $(PROGRAM_NAME): $(OBJS)
 #	$(CC) $(CFLAGS) $(LDFLAGS) -o $(PROGRAM_NAME) $(OBJS)
 
 installdirs:
-	@[ "$(ON_WINDOWS)" = "1" ] && echo "Do not use install rules on Windows" && exit 1
+	@[ "$(ON_WINDOWS)" = "1" ] && echo "Do not use install rules on Windows" && exit 1 || exit 0
 	test -e $(DESTDIR)$(LIB_DIR) || $(MKDIR) $(DESTDIR)$(LIB_DIR)
+	test -e $(DESTDIR)$(INC_DIR) || $(MKDIR) $(DESTDIR)$(INC_DIR)
 	test -e $(DESTDIR)$(MAN7_DIR) || $(MKDIR) $(DESTDIR)$(MAN7_DIR)
 
 install: sharedlib staticlib installdirs
-	@[ "$(ON_WINDOWS)" = "1" ] && echo "Do not use install rules on Windows" && exit 1
-	$(INSTALL_DATA)	$(PROGRAM_NAME).so $(DESTDIR)$(LIB_DIR)/$(PROGRAM_NAME).so.$(VERSION)
-	$(LN)		$(PROGRAM_NAME).so.$(VERSION) $(DESTDIR)$(LIB_DIR)/$(PROGRAM_NAME).so.$(VERSION_MAJOR)
-	$(LN)		$(PROGRAM_NAME).so.$(VERSION) $(DESTDIR)$(LIB_DIR)/$(PROGRAM_NAME).so
+	@[ "$(ON_WINDOWS)" = "1" ] && echo "Do not use install rules on Windows" && exit 1 || exit 0
+	$(INSTALL_DATA)	$(PROGRAM_NAME).$(SUFFIX) $(DESTDIR)$(LIB_DIR)/$(PROGRAM_NAME).$(SUFFIX).$(VERSION)
+	$(LN)		$(PROGRAM_NAME).$(SUFFIX).$(VERSION) $(DESTDIR)$(LIB_DIR)/$(PROGRAM_NAME).$(SUFFIX).$(VERSION_MAJOR)
+	$(LN)		$(PROGRAM_NAME).$(SUFFIX).$(VERSION) $(DESTDIR)$(LIB_DIR)/$(PROGRAM_NAME).$(SUFFIX)
 	$(INSTALL_DATA)	$(PROGRAM_NAME).a $(DESTDIR)$(LIB_DIR)/$(PROGRAM_NAME).a
 	$(INSTALL_DATA)	$(PROGRAM_NAME).h $(DESTDIR)$(INC_DIR)/$(PROGRAM_NAME).h
 	$(INSTALL_DATA)	$(PROGRAM_NAME).7 $(DESTDIR)$(MAN7_DIR)/$(PROGRAM_NAME).7
 
 uninstalldirs:
-	@[ "$(ON_WINDOWS)" = "1" ] && echo "Do not use install rules on Windows" && exit 1
+	@[ "$(ON_WINDOWS)" = "1" ] && echo "Do not use install rules on Windows" && exit 1 || exit 0
 	-test -e $(DESTDIR)$(LIB_DIR) && $(RMDIR) $(DESTDIR)$(LIB_DIR)
 	-test -e $(DESTDIR)$(INC_DIR) && $(RMDIR) $(DESTDIR)$(INC_DIR)
 	-test -e $(DESTDIR)$(MAN7_DIR) && $(RMDIR) $(DESTDIR)$(MAN7_DIR)
 
 uninstall: uninstalldirs
-	@[ "$(ON_WINDOWS)" = "1" ] && echo "Do not use install rules on Windows" && exit 1
+	@[ "$(ON_WINDOWS)" = "1" ] && echo "Do not use install rules on Windows" && exit 1 || exit 0
 	$(RM)	$(DESTDIR)$(LIB_DIR)/$(PROGRAM_NAME).so.$(VERSION)
 	$(RM)	$(DESTDIR)$(LIB_DIR)/$(PROGRAM_NAME).so.$(VERSION_MAJOR)
 	$(RM)	$(DESTDIR)$(INC_DIR)/$(PROGRAM_NAME).a
