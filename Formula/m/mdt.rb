class Mdt < Formula
  desc "Command-line markdown todo list manager"
  homepage "https://github.com/basilioss/mdt"
  url "https://github.com/basilioss/mdt/archive/refs/tags/1.4.0.tar.gz"
  sha256 "542998a034c93ca52e72708c1d3779e597f778faf2ee70d8cf11873185332d31"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d552e67d2fb68fb208eb53150f629fd69fd1f185f679932c985636dec17aa95b"
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
