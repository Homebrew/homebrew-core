class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.31.0.tar.gz"
  sha256 "f82694202f584d281a166bd5b7e877565f96a94807af96325c8f43643d76cb44"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b13e0dddc9622fac2670443ffc1e782411fb959108b9452ed0b09f17bc59250"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a29ff9f7c8cf4cec8cc4caa91c3d164b1d80c224d5de76dfda8ab7a9578129b8"
    sha256 cellar: :any_skip_relocation, monterey:       "76e1669a3c6de7f3027fd42de855f8578875940ad9bc2c4bfe572233f4ec79ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "5493887df938d10af71efb0e80889619c61e73b9cf5f117e87df945c88abf3f9"
    sha256 cellar: :any_skip_relocation, catalina:       "388a31d52084fb6399abaa5fe05d0b7e88e25e911f8904e71a606214bced862c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce0cd8ba4e113a782ad3a5f8a05dfdfe5cf202b9f18980c41c4729ce31eceb87"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
