class ChooseGui < Formula
  desc "Fuzzy matcher that uses std{in,out} and a native GUI"
  homepage "https://github.com/chipsenkbeil/choose"
  url "https://github.com/chipsenkbeil/choose/archive/refs/tags/1.3.1.tar.gz"
  sha256 "63d69aa24eca3e397ca5d6ca8da57921c1f1ed02c34e6ef351b999bc208861e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6945adef420d93507a9b315deb745ede15be54bd5f3f7d2b739e66e63a641ae4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2f335db4a15c2bb6d13f34e2247b88537b30bdb29d88f315c00125a5ad510a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea87b1a590c751e812b4fada4882951b3cda17c489ab4f6a1fd4398acbe262aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "630408a8095e21ae5a7f25892d49edd0936e0bc397d85af335f898d3d8c45508"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d742aa98d6c503e953531bcaac5807254e820a2f0c4888faa06a791f292365a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "792c8eb2aacfd6b7d2f45d2f32900052bc0be0fc478ed7b962ac012b67052af4"
    sha256 cellar: :any_skip_relocation, ventura:        "051c460b229a5650d4acf03b9ab5c5627b50b5dd82285ff6d203ad611f7eaedb"
    sha256 cellar: :any_skip_relocation, monterey:       "3fb160658f91298dbebbdca13ddd30c01565dd41146d07bc739f27a868a240a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bebb256288062b620e845055833832c14a98f835b330e3c1fa866390a880e24"
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
