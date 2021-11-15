class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.2.0.tar.gz"
  sha256 "2873f42f89c0553b7105bda4b3edb93584ba3a163b31bbfae6b6e1bc203ca8c3"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e0abedae03cc5c265657ce7d577e135f5e858b596bc3a0d23422061e0f5ba88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a4717d41423c61d4ae8a541c22883dc3c2f58da50570470f16218d42cb16052"
    sha256 cellar: :any_skip_relocation, monterey:       "be0b9f0b27659f8bf81361e240e4ca3f9edb59538717c3c4324c1ba05a2baa23"
    sha256 cellar: :any_skip_relocation, big_sur:        "509aae19c82540eea310c94d68bac5e69a0cf576bd391ed1eec9ac01c43902cb"
    sha256 cellar: :any_skip_relocation, catalina:       "ec15d020d408385190a958aa7300cbd8e904bc992653e8d029a2e44a311c8823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b19c222d9d00843fea09df330cadf7e6fb67d9abf26f02e592731d9b6e733b3"
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
