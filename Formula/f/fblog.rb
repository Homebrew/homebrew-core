class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "1bf50a4b7f1775dba0bacfb5e7709baf8abebd3e4cca2f728a1976950b0d2a2e"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a22a1f6a193eb2cf7be48a91f43ac78ad8e627e3677ff1b0a318ac5a43ed7bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4d15872508ab2026829d06485452a6b6050ad17247a6c96088e9dce7c1b96e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c849c7d66d2b5d3904c9fec687eff8554d69d4dd849031354471dc5eb160a32b"
    sha256 cellar: :any_skip_relocation, sonoma:        "093ae9649047ff2c0ee5e57d0b90a8c46b83f27482303f92f5549c31387e029a"
    sha256 cellar: :any_skip_relocation, ventura:       "df68c21a6673bda9d7b0dc4cf0c576a39e13f3133ccfb1d58e868b4b07f891fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2035f95975a7cc0b6aaa637318e4b42ce7a98f9539a7d7e63637acc337fcff3e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
