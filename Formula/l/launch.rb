class Launch < Formula
  desc "Command-line launcher for macOS, in the spirit of `open`"
  homepage "https://sabi.net/nriley/software/#launch"
  url "https://sabi.net/nriley/software/launch-1.2.5.tar.gz"
  sha256 "486632b11bee04d9f6bcb595fd2a68b5fde2f748ebdc182274778cc5cf97ff70"
  license "BSD-3-Clause"
  head "https://github.com/nriley/launch.git", branch: "master"

  livecheck do
    url "https://sabi.net/nriley/software/"
    regex(/href=.*?launch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d2a2a782722ff22b6b83014e8d62aed20453c44ec04cbe797daa4e2cec79882e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "54d531c3c1a2663b5666ac7f0b7089173994b80420fcbfff0245810e46c26121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4635ec437a42cd80e46447ec0e86fd3744d5c4a338369c88ccb9128113febdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df847f012511a511c1e2b9b70dd171a7a8e3d8a829cc58cb20a113ef6dc5a526"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a22a51899be9434558af2a787f253c90af7b1dc5dc17017096b221c0b85dc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8bc9136d5da0270c108662086bebfd5cf74cd5eb82a773318e9be1b7a61b986"
    sha256 cellar: :any_skip_relocation, sonoma:         "6730cf208e9a8c8e771c8f20ca6e39228096a893cb476e3d25ff81e33e77ccce"
    sha256 cellar: :any_skip_relocation, ventura:        "55dd24d6048328483994c1d22a56a4c26317399322ec52fbf81968bc1b64a4d0"
    sha256 cellar: :any_skip_relocation, monterey:       "4813f636dd057ce7e61e02019d3886e2519ca4189c2ee1a98a2f9fa111412225"
    sha256 cellar: :any_skip_relocation, big_sur:        "0190475edf924787849170f68ab44589bbb41e8eb8e72dc86fefb4f15954ce00"
    sha256 cellar: :any_skip_relocation, catalina:       "1d48da3f7c9c226fe622e83b1ff37bca0b960ab6979b01f2bf2e4b8010febacc"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    rm_r("launch") # We'll build it ourself, thanks.
    xcodebuild "-configuration", "Deployment", "SYMROOT=build", "clean"
    xcodebuild "-arch", Hardware::CPU.arch, "-configuration", "Deployment", "SYMROOT=build",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    man1.install Utils::Gzip.compress("launch.1")
    bin.install "build/Deployment/launch"
  end

  test do
    assert_equal "/", shell_output("#{bin}/launch -n /").chomp
  end
end
