class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.2.2.tar.gz"
  sha256 "79cfb686b940dfb11ddfaf732aa71189d18729ef6ee8f4538a3ebf66c73a0b90"

  bottle do
    cellar :any_skip_relocation
    sha256 "164c2707cfd8cee61e42aea69a19aba4ff6229535de6d24528a910bf502cb1da" => :catalina
    sha256 "30f725a2c1b3b94274a20667fcc7c7274d60a1c75617cec83e8b69364b36169a" => :mojave
    sha256 "93b34b1ef50168d6dfcfdbad0ccd7cfaef069f7a188ed9211b7bd607011d42bf" => :high_sierra
  end

  depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1000
  depends_on "rust" => :build

  def install
    if DevelopmentTools.clang_build_version <= 1000
      ENV["HOMEBREW_CC"] = "llvm_clang"
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    end
    system "cargo", "install", "--locked", "--root", prefix, "--path", "./b3sum/"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
