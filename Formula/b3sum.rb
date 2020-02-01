class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.1.3.tar.gz"
  sha256 "54a0eaa0a8f8fc9114251e7ad1d00d97b1c5cb96da6e648969b6b5b5a9a3bf87"

  bottle do
    cellar :any_skip_relocation
    sha256 "e76b0fe70a4c1ab17b1f1774131b64c3462a94421e8511eac6a4842d0ee2fec7" => :catalina
    sha256 "5c483f3a96121031d5f0396aced6a07f663d606fc3ed1b8834edcd6776ffc674" => :mojave
    sha256 "13549dfba0c2fa956ebc8d263a6de881b8b1ff01d23680013e93d50396037fec" => :high_sierra
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
