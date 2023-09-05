class Countdown < Formula
  desc "Terminal countdown timer"
  homepage "https://github.com/antonmedv/countdown"
  url "https://github.com/antonmedv/countdown/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "73f05360b7d937d5b1ac922dc1f2d311c5baef791117ca8e0fa09628749e843b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "297d047b375d44a55a41dbd35fd71b86bb64e415960c0422c5e43a103857e895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "297d047b375d44a55a41dbd35fd71b86bb64e415960c0422c5e43a103857e895"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "297d047b375d44a55a41dbd35fd71b86bb64e415960c0422c5e43a103857e895"
    sha256 cellar: :any_skip_relocation, ventura:        "cc2daf7aba1e2e9be66e2f2efdb953079ab4d4a28db4760a666363f71101748b"
    sha256 cellar: :any_skip_relocation, monterey:       "cc2daf7aba1e2e9be66e2f2efdb953079ab4d4a28db4760a666363f71101748b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc2daf7aba1e2e9be66e2f2efdb953079ab4d4a28db4760a666363f71101748b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51546b7230f8b005f1d1826e1385d1e54545141dbf2fc82073116edd3e541640"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pipe_output bin/"countdown", "0m0s"
  end
end
