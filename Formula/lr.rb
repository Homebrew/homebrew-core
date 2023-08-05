class Lr < Formula
  desc "File list utility with features from ls(1), find(1), stat(1), and du(1)"
  homepage "https://github.com/leahneukirchen/lr"
  url "https://github.com/leahneukirchen/lr/archive/refs/tags/v1.6.tar.gz"
  sha256 "5c1160848b5379e2a51c56be5642b382f4ba2b579b7f43834c80e6d856c09b10"
  license "MIT"
  head "https://github.com/leahneukirchen/lr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ef4b3efd8f0b8e68cb1d02f600cfae5c780c4227ddf0193e010f3a328e95f23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "772570dfa98bac636b0285407a8bdc0b987288a37d2c2d2a21ad448fadc60e65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dadc15568d278a97b4bc79e4218680f9f4f3a4d4cc5da6117ffb70093e7aa0e9"
    sha256 cellar: :any_skip_relocation, ventura:        "8cb55dda590f5e3e42ee33b7b92e45db3c92f28036b271b0ca391e2a98afeda6"
    sha256 cellar: :any_skip_relocation, monterey:       "13dca68cb7edf7dacb30fb894688e9c6384b6e26cc39d47018f5a5baf2120cca"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a4acf369b4f1056a98a7bc61daa685df1254a087087a5a528d34fc9d561ca39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b0e58ef6033c28d27113e53b22f28ac674a4f58d869a362dcdba5427068640a"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match(/^\.\n(.*\n)?Library\n/, shell_output("#{bin}/lr -1"))
  end
end
