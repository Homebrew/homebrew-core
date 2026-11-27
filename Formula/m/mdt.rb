class Mdt < Formula
  desc "Command-line markdown todo list manager"
  homepage "https://github.com/basilioss/mdt"
  url "https://github.com/basilioss/mdt/archive/refs/tags/1.4.0.tar.gz"
  sha256 "542998a034c93ca52e72708c1d3779e597f778faf2ee70d8cf11873185332d31"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    manifest_sha256 "d2d276d6aef2b494f491041fba56cabb65737d0214ef8273e7a6a1a342359ddb"
    sha256 cellar: :any_skip_relocation, all: "8d78fb5808e2fcae85e5e07e39c1c3b9aabe54d2acf8888d98330f7b45eec989"
  end

  depends_on "gum"

  def install
    bin.install "mdt"
  end

  test do
    assert_equal "mdt #{version}", shell_output("#{bin}/mdt --version").chomp
    assert_match "Error: Got an unexpected argument '--invalid'.", shell_output("#{bin}/mdt --invalid 2>&1", 1)
  end
end
