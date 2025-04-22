class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "53f686808ef37728922ad22e8a5560f4caf1d214d706639ef8eca6e72b891697"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81646c87b6a7b3f3f74de589a2246cc12f9477a1b04a1fa3dadc08d991842a74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81646c87b6a7b3f3f74de589a2246cc12f9477a1b04a1fa3dadc08d991842a74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81646c87b6a7b3f3f74de589a2246cc12f9477a1b04a1fa3dadc08d991842a74"
    sha256 cellar: :any_skip_relocation, sonoma:        "658d2c03d442e49143a223a77d49a462ec2ce5ee40d22da4a932e178920234d4"
    sha256 cellar: :any_skip_relocation, ventura:       "658d2c03d442e49143a223a77d49a462ec2ce5ee40d22da4a932e178920234d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81646c87b6a7b3f3f74de589a2246cc12f9477a1b04a1fa3dadc08d991842a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81646c87b6a7b3f3f74de589a2246cc12f9477a1b04a1fa3dadc08d991842a74"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
