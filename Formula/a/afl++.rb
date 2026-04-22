class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.35c.tar.gz"
  version "4.35c"
  sha256 "b6e3d90ad65c7adb5681803126454f979e15b1e74323aecf2603cab490202249"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c2df51739b4ef3e4bbf9ada1b5ab57c8fffc848fba7b98ff6fcdd511780b8bc2"
    sha256 arm64_sequoia: "f97a1c2a01bed341f7e6b69ff188b151e5dc834d1dd4f14aee67c53bf0b970c5"
    sha256 arm64_sonoma:  "9a12e059552523cd95101619d18cb4badcb30d4971234aad8ed7799044e5d63c"
    sha256 sonoma:        "297c153c14b348dd98806bd00f0307e6313f136201e5b3c82893c458143ab649"
    sha256 arm64_linux:   "fa49c337fd021355f5caf47f14b0b48267576edb017441b033fe7562c3717fec"
    sha256 x86_64_linux:  "59cc5f6537182866131bece8d8f9d79f7cab1f3b871fe0eaf5bfac7275b3c333"
  end

  depends_on "coreutils" => :build
  depends_on "llvm"
  depends_on "python@3.14"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # The Makefile will insist on compiling with LLVM clang even without this.
  fails_with :clang
  fails_with :gcc

  # Backport fix for LLVM 22
  patch :DATA
  patch do
    url "https://github.com/AFLplusplus/AFLplusplus/commit/5e8278daa453328aeb5c599e0ff359e5057108f0.patch?full_index=1"
    sha256 "49fc530c92b716f7762c2bf45c8e287b2d22aff907520bff6ba3a5687169d945"
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"

    if OS.mac?
      # Disable the in-build test runs as they require modifying system settings as root.
      inreplace ["GNUmakefile", "GNUmakefile.llvm"] do |f|
        f.gsub! "all_done: test_build", "all_done:"
        f.gsub! " test_build all_done", " all_done"
      end
    end

    llvm = Formula["llvm"]
    make_args = %W[
      PREFIX=#{prefix}
      CC=clang
      CXX=clang++
      LLVM_BINDIR=#{llvm.opt_bin}
      LLVM_LIBDIR=#{llvm.opt_lib}
    ]

    system "make", "source-only", *make_args
    system "make", "install", *make_args
    return unless llvm.keg_only?

    bin.env_script_all_files libexec, PATH: "#{llvm.opt_bin}:${PATH}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~CPP
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    CPP

    system bin/"afl-c++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end

__END__
diff --git a/docs/Changelog.md b/docs/Changelog.md
index 29d700094e..e81124ad75 100644
--- a/docs/Changelog.md
+++ b/docs/Changelog.md
@@ -4,7 +4,11 @@
   release of the tool. See README.md for the general instruction manual.
 
 
-### Version ++4.35a (dev)
+### Version ++4.36a (dev)
+  - ...
+
+
+### Version ++4.35a (release)
   - GUIFuzz++ merged: Unleashing Grey-box Fuzzing on Desktop Graphical User
                       Interfacing Applications
     https://futures.cs.utah.edu/papers/25ASE.pdf
