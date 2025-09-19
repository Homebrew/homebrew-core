class Maclaunch < Formula
  desc "Manage your macOS startup items"
  homepage "https://github.com/hazcod/maclaunch"
  url "https://github.com/hazcod/maclaunch/archive/refs/tags/2.5.tar.gz"
  sha256 "b2d5f8669cd2c09096759f6472db4c8c50a3abf90581e6d629f7c5128bbfa88c"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e2e8116deaaa5e73abcb0d97dedb8d6b708b0b7cfdab81edc35c885db833522b"
  end
  depends_on :macos

  def install
    bin.install "maclaunch.sh" => "maclaunch"
  end

  test do
    system bin/"maclaunch", "list"
  end
end
