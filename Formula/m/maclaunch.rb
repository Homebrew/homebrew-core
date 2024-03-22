class Maclaunch < Formula
  desc "Manage your macOS startup items"
  homepage "https://github.com/hazcod/maclaunch"
  url "https://github.com/hazcod/maclaunch/archive/refs/tags/2.5.tar.gz"
  sha256 "b2d5f8669cd2c09096759f6472db4c8c50a3abf90581e6d629f7c5128bbfa88c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "639bd667f12534988b5419a710d59ec0f69bc1a2e274d31d055273e9e6faf7c6"
  end
  depends_on :macos

  def install
    bin.install "maclaunch.sh" => "maclaunch"
  end

  test do
    system bin/"maclaunch", "list"
  end
end
