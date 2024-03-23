class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "ada68589b916ce535cb49a37370b11c2bc9145e444f6e9036a3d74f301de2189"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43fcf01ea69f721a3dc86165bc9597dd5e76f1926744275b838c2112220e6b6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ee4036b4dc8dc9c6d7d8f6d8555a69b004226ec25049a7aab3624cca34b43fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a8fef02b3300ca11f60b4b6c8ecf0af6ab95f964cb3b067ba34bd7b39396ba3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85ffdc1c6fb323a24b572e1d39dd91ebd3d45822cf4dec31be3f34603f415a33"
    sha256 cellar: :any_skip_relocation, sonoma:         "a662cdc7a510916f83b5883f06748fd2ac506e1caf92364f8db8eed47fbecbcc"
    sha256 cellar: :any_skip_relocation, ventura:        "c09066ae27648232ce2854359c01b16ec2c05205dc318435524b9470279a4b87"
    sha256 cellar: :any_skip_relocation, monterey:       "ed288790e1bb931223e9edd5aaca90562595058f9edf6f2ce726c225e2caecd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "73232c8f4c1fcb92010d8620ca76bded2da5f1a8040353a4d0320983b4d247d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0698d25d84770b0c1649370a0afa23fe32cca3bf3007d5418034d4e8c45bd38"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp, "15"
  end
end
