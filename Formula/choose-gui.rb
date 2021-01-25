class ChooseGui < Formula
  desc "Fuzzy matcher that uses std{in,out} and a native GUI"
  homepage "https://github.com/chipsenkbeil/choose"
  url "https://github.com/chipsenkbeil/choose/archive/1.2.1.tar.gz"
  sha256 "cab6083be6429e9c67bd0026aedf8bd76675a2dea045d235a973fb61b106aeaf"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "83c49f5cf2fd316b1dac396341921547b7a6db1b33710d0a5413cb53ba100d8b" => :big_sur
    sha256 "e8abc11fca77fb82fc0cbf01c8a4a36a0abdd490f63066bd490ca1ff23af8ccf" => :arm64_big_sur
    sha256 "8df952db2e54267c80dadb67f0da6a249fb0e3d58c92e1d7ac9e791ab8157f76" => :catalina
    sha256 "0f045585cc3cfb9308e79156e9fbdcea273f7a6ec14da690d3000b445cf82689" => :mojave
    sha256 "327a21c741b66cc4484dfba8dcdf3cdd1c4d6f30b8f9e15cd4dbd59b87501e66" => :high_sierra
  end

  depends_on xcode: :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build", "clean"
    xcodebuild "SDKROOT=", "SYMROOT=build", "-configuration", "Release", "build"
    bin.install "build/Release/choose"
  end

  test do
    system "#{bin}/choose", "-h"
  end
end
