class LibunwindHeaders < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/libunwind/libunwind-201.tar.gz"
  sha256 "415daa5481e0cd5923b2a923c6906586e7231ebfb9fabf06bc5230bd7a7c7140"
  license "APSL-2.0"

  livecheck do
    url "https://opensource.apple.com/tarballs/libunwind/"
    regex(/href=.*?libunwind[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4e338982c769a851a7a3083e7cb9f99931436bcc85b767550e260688733b0b0"
  end

  keg_only :shadowed_by_macos, "macOS provides libunwind.dylib (but nothing else)"

  def install
    cd "libunwind" do
      include.install Dir["include/*"]
      (include/"libunwind").install Dir["src/*.h*"]
    end
  end
end
