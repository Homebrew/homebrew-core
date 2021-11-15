class ChooseGui < Formula
  desc "Fuzzy matcher that uses std{in,out} and a native GUI"
  homepage "https://github.com/chipsenkbeil/choose"
  url "https://github.com/chipsenkbeil/choose/archive/1.2.1.tar.gz"
  sha256 "cab6083be6429e9c67bd0026aedf8bd76675a2dea045d235a973fb61b106aeaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37b3b5778df9ba0fc55ff277bb2ab4a6d920ba21875460c6e7ab4d944411e21a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8abc11fca77fb82fc0cbf01c8a4a36a0abdd490f63066bd490ca1ff23af8ccf"
    sha256 cellar: :any_skip_relocation, monterey:       "11f10c376ce467c5cee44f5dd22db0970ebd5bc2c5a3959995a3846fed39166b"
    sha256 cellar: :any_skip_relocation, big_sur:        "83c49f5cf2fd316b1dac396341921547b7a6db1b33710d0a5413cb53ba100d8b"
    sha256 cellar: :any_skip_relocation, catalina:       "8df952db2e54267c80dadb67f0da6a249fb0e3d58c92e1d7ac9e791ab8157f76"
    sha256 cellar: :any_skip_relocation, mojave:         "0f045585cc3cfb9308e79156e9fbdcea273f7a6ec14da690d3000b445cf82689"
    sha256 cellar: :any_skip_relocation, high_sierra:    "327a21c741b66cc4484dfba8dcdf3cdd1c4d6f30b8f9e15cd4dbd59b87501e66"
  end

  depends_on xcode: :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build", "clean"
    xcodebuild "-arch", Hardware::CPU.arch, "SDKROOT=", "SYMROOT=build", "-configuration", "Release", "build"
    bin.install "build/Release/choose"
  end

  test do
    system "#{bin}/choose", "-h"
  end
end
