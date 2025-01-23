class ChooseGui < Formula
  desc "Fuzzy matcher that uses std{in,out} and a native GUI"
  homepage "https://github.com/chipsenkbeil/choose"
  url "https://github.com/chipsenkbeil/choose/archive/refs/tags/1.4.1.tar.gz"
  sha256 "71cbe036fd60e18522b35b588196acc82ec2f6b9ab49a6da0472dc01e6d1ae54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fc3426cef66b0713adacb38e27ee348aad346dc3136c382b73af3c1d9de4a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58252dbc3802b396738153c38323f82efb5c193f9f4c411aa2d8d87606cc83d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da0631fa22b646a92b6bde76d3bdda68e91c7c625cb6e16377888ce58d1c3de6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bedc4ca3cac331edc6b895f30d6140ac83a430d65a03f5a6783b07877f98e7e1"
    sha256 cellar: :any_skip_relocation, ventura:       "0b13228bbef3d92d71e830c26ec836f730a8d1b4f577211ebed04134cbb69f60"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-rust", because: "both install a `choose` binary"

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build", "clean"
    xcodebuild "-arch", Hardware::CPU.arch, "SDKROOT=", "SYMROOT=build", "-configuration", "Release", "build"
    bin.install "build/Release/choose"
  end

  test do
    system bin/"choose", "-h"
  end
end
