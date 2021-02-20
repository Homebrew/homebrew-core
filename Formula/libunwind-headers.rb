class LibunwindHeaders < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/libunwind/libunwind-200.10.tar.gz"
  sha256 "82ead8e12f7d5e70024ae8d116aa68755fb7932090e16f6077f44c7731abbede"
  license "APSL-2.0"

  livecheck do
    url "https://opensource.apple.com/tarballs/libunwind/"
    regex(/href=.*?libunwind[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle :unneeded

  keg_only :shadowed_by_macos, "macOS provides libunwind.dylib (but nothing else)"

  def install
    cd "libunwind" do
      include.install Dir["include/*"]
      (include/"libunwind").install Dir["src/*.h*"]
    end
  end
end
