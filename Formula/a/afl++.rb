class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus/"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.35c.tar.gz"
  version "4.35c"
  sha256 "b6e3d90ad65c7adb5681803126454f979e15b1e74323aecf2603cab490202249"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+c)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "466e6e4777a1f0fefd04f77ccd69ec2f11466a54df7a9462403a531b3184e581"
    sha256 arm64_sequoia: "3b6eed6895b1a96a584fdd37fdd1d5e92df00c237a24b92cbe2deb71fabe7c15"
    sha256 arm64_sonoma:  "75d6675d206ee531ea0ef7f21d014853a13cbf27166f4215323a45fc4abffbd9"
    sha256 sonoma:        "2eadeffff6541c592e2813e1fe1d50f85168ab240384356549d4b851e0033566"
    sha256 arm64_linux:   "cc0659688a67e91ddb309a58beb4035edd03166ffddf018fdfde10db7598c2a7"
    sha256 x86_64_linux:  "d812d4e274c1258b37809cb03bc2100b5f00fb99b6164ce665c1d0043a56ef92"
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
