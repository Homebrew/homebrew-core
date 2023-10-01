class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.20.0.tar.gz"
  sha256 "29988118bf57d8925ab15ec5bf039d4ed23bb6f11e90b65b9e599ccbb3e649e0"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53a95bc9c5c275fceb4777e158275dd06f4881c873333b640a4515063edd7e32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36cc3954fcfb88e4bb651f8070a8b6093f63bfac20dc7f6f24febfe36422faf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e08b011305166c4bb86ffaa667cfabc644fd3e286dbe166a55e50d1b8e5cfb2"
    sha256 cellar: :any_skip_relocation, ventura:        "1c5b433f12186fca85a224d5dea2a35814a64ca86ee380f1c38d387966d893e0"
    sha256 cellar: :any_skip_relocation, monterey:       "0973c0f02dc6de227f398a432e6d7af5c9d5bccb0887ba4e696017c8440c94e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "994b47f468be903faf00796cd2d5a6f348015fa711f9055c407a76367b5f5d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfbf0ec3b2de9987df9cad57ef953c40bc193154d551b6ca73053b6f56645a29"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end
