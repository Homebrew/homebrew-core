class Launch < Formula
  desc "Command-line launcher for macOS, in the spirit of `open`"
  homepage "https://sabi.net/nriley/software/#launch"
  url "https://sabi.net/nriley/software/launch-1.2.4.tar.gz"
  sha256 "79ed9ca7548d6758f74f74dde003748fcb91bef973ac82262819952fed494907"
  head "https://github.com/nriley/launch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2228493f7a13892ca91063711ab3b471f7be882f0252d22717ee5e614caec44" => :high_sierra
    sha256 "fda28496bffe1ef0e34ef99b0a553f767869a637b71a69700f11f96411849cbe" => :sierra
    sha256 "f6219951bf7d3a4360e6f0246c2a54f2e894bda93a6c4ed5e147047f661af567" => :el_capitan
  end

  depends_on :xcode => :build

  def install
    rm_rf "launch" # We'll build it ourself, thanks.
    xcodebuild "-configuration", "Deployment", "SYMROOT=build", "clean"
    xcodebuild "-configuration", "Deployment", "SYMROOT=build"

    man1.install gzip("launch.1")
    bin.install "build/Deployment/launch"
  end

  test do
    assert_equal "/", shell_output("#{bin}/launch -n /").chomp
  end
end
