class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/archive/v1.7.tar.gz"
  sha256 "ad44d28700d346ceb9a70ae92d36306d42e187fc1af19fa2c7a3ab7dc18742ef"

  # The version shipped with Mac OS X is missing two symbols
  # therefore use the version from Homebrew
  depends_on "libffi"
  depends_on "pkg-config" => :build

  # The install command in the Makefile uses GNU coreutils syntax
  # which is incompatible with BSD's install and needs patching
  patch :DATA

  def install
    cd "unix" do
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    # Test the FFI module
    (testpath/"ffi-hello.py").write <<-EOS.undent
      import ffi

      libc = ffi.open("libc.dylib")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system "#{bin}/micropython", "ffi-hello.py"
  end
end

__END__
diff --git a/unix/Makefile b/unix/Makefile
index 6d6239f..c556473 100644
--- a/unix/Makefile
+++ b/unix/Makefile
@@ -186,8 +186,9 @@ PIPSRC = ../tools/pip-micropython
 PIPTARGET = pip-micropython
 
 install: micropython
-	install -D $(TARGET) $(BINDIR)/$(TARGET)
-	install -D $(PIPSRC) $(BINDIR)/$(PIPTARGET)
+	install -d $(BINDIR)
+	install $(TARGET) $(BINDIR)/$(TARGET)
+	install $(PIPSRC) $(BINDIR)/$(PIPTARGET)
 
 # uninstall micropython
 uninstall:
