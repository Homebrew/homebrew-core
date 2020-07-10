class B3sum < Formula
  desc "The BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.3.5.tar.gz"
  sha256 "0f6892b7216291ab1a5b16cc40c01d7310b7d420ee38e779e5c45e49ca456e6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca1b6befbfcc0f9b29988734eb9e7f4a4733f93eaad4fd044979dd92b6e7db27" => :catalina
    sha256 "ffa534e58550dd15036ab9cffc692b1d1fac2fe8cd2f69edda255e056169c927" => :mojave
    sha256 "1b12778aa33337ea2212e925fb0779a15b0eac8d939a5c402e8271ea91e12815" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end
