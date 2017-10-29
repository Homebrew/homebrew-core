class Py3c < Formula
  desc "A Python 2/3 compatibility layer for C extensions"
  homepage "http://py3c.readthedocs.org"
  url "https://github.com/encukou/py3c/archive/v0.8.tar.gz"
  sha256 "c97e538ed25b6fe76f0ff97e9de9dbf3b08cc46b30a5a29d80a991f50c9dfc0d"

  depends_on "pkg-config" => :build

  # Prevent strange behaviour of $(realpath ...) on OSX returning an empty path
  # by ensuring that the path exists before converting the pkg-config file.
  patch :DATA

  def install
    system "make", "install", "prefix=#{prefix}", "includedir=#{include}"
  end

  test do
    system "test \"$(pkg-config --cflags py3c)\" = \"-I#{include}\""
  end
end

__END__
diff --git -u a/Makefile b/Makefile
--- a/Makefile
+++ b/Makefile
@@ -35,7 +35,10 @@
 test-%-cpp: build-%-cpp
 	TEST_USE_CPP=yes PYTHONPATH=$(wildcard test/build/lib*) $* test -v
 
-py3c.pc: py3c.pc.in
+$(includedir):
+	mkdir -p $(includedir)
+
+py3c.pc: py3c.pc.in $(includedir)
 	sed -e's:@includedir@:$(realpath $(includedir)):' $< > $@
 
 install: py3c.pc
