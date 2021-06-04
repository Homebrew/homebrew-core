class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-851.27.tar.gz"
  sha256 "f0ac5a6611a5665b9745a0a1b1b7b516866c647b8f6361e18af9f671a85d8f27"
  license "APSL-2.0"

  livecheck do
    url "https://opensource.apple.com/tarballs/dyld/"
    regex(/href=.*?dyld[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "030bc735c39f496f111c071ac3d0f2b5fc73e03e2d969ac30a6a8ef3362e9148"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
