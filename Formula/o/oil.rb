class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oil-0.28.0.tar.gz"
  sha256 "7fbbad0b5a3f91ccc89aa4b124da2d7b86be09c784a18290b9a76ede043631f3"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4ed33cb8bd4e5b3eab753bdc2966907f1131f5e2de75c06374bcf4b3798eee1b"
    sha256 arm64_sequoia: "d7f33bcf21c4d633100e696f18c3ac2da6a5040ea33b70b9150c342cf48e82a5"
    sha256 arm64_sonoma:  "44a9ecb0c3f6fbba0adfb0cb705c0fd598188d21718abc62d2e8ddc5be9a32a4"
    sha256 arm64_ventura: "c4a576863f7a1f1b5b03c54e8fc13f48c6e1f66b36532e52ec554d131b8e914e"
    sha256 sonoma:        "9b141902a28ddf300bad945a5fbb29722ed033f67e7df1107670569e08c4a3b8"
    sha256 ventura:       "9f5cc327440859fe2de73c14326a0e02790ef42f2beb5d573cee0e06449100fc"
    sha256 arm64_linux:   "d37d926656cb2143910eb8eb1591175c7e479508c665a5069c2e9d6ef9e62e2d"
    sha256 x86_64_linux:  "cb4af168e569f703d4ed53eb46c52677089ccec0cc5bd391fdc4103666e623ec"
  end

  depends_on "readline"

  conflicts_with "oils-for-unix", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    # Workaround for newer Clang/GCC
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"

    # patchelf.rb cannot handle ELF with appended zip data so keep the original files
    # used at https://github.com/oils-for-unix/oils/blob/master/Makefile#L189-L190
    libexec.install "_build/oil/ovm-opt.stripped", "_build/oil/bytecode-opy.zip" if build.bottle? && OS.linux?
  end

  def post_install
    if libexec.exist?
      bin.install libexec/"ovm-opt.stripped" => "oil.ovm"
      (bin/"oil.ovm").binwrite((libexec/"bytecode-opy.zip").binread, mode: "a")
      (bin/"oil.ovm").chmod(0555)
      rm_r(libexec)
    end
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
