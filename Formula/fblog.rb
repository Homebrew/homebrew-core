class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/v2.1.0.tar.gz"
  sha256 "a5240bcc72ba5c49eb5ccdf1cb8bd0e0a91159b3aba41ffbef4de5737fb5d2ec"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "073b76d7c246f672906e7ededa27fb4791f7282a458638829da9e8e4667ef8c9" => :catalina
    sha256 "16bdfe547bdad0b581ac563e1420623df35eda3a52e293f229f6e84e46010798" => :mojave
    sha256 "8ddd09ea7663352daba5ffeb48a35f05bab17ab729dc24d3e0bb1f8c3aee1db9" => :high_sierra
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
