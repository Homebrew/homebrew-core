class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.3.3.tar.gz"
  sha256 "33af07ddb519818aca75f876fc704c1bd1b92daee04d9ed6d39ded006356b1e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "96f6ab17edaf5c0bd014e4650da92a1afeee5b19890802ede4638259491cf0d4" => :catalina
    sha256 "3326d2e6ed59e1601e431e49c4a66551aaf07fb27be9552b77363ed289d7479b" => :mojave
    sha256 "7a1a71bd06e2a1d245c787b85650eb6be8ef279d1440e4a9323d9bb020850bb8" => :high_sierra
  end

  depends_on "rust" => :build

  def install
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
