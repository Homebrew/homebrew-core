class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/0.3.8.tar.gz"
  sha256 "0a418acc3beacc212fd360ab16e96c9a830b519a8dab321885900efc2db8d3b4"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "13905a43f9c0dae761cef82a377ed4f1444f41c904cd8d3842077ac2cb364713"
    sha256 cellar: :any_skip_relocation, big_sur:       "4dcaea454f3dff3b9a2d7fe6840e106d9f54c542f98e8b1316ae23910c275d61"
    sha256 cellar: :any_skip_relocation, catalina:      "a2999c341c1bd27544632d41e1de65cb6004c2ecca684a1fe5e6013d3d670c18"
    sha256 cellar: :any_skip_relocation, mojave:        "a5b935ad1560e09877f2ff0f2daeb8c990c8104eface1c985b81c7f80ea8ca4f"
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
