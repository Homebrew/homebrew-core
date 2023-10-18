class Ddrescue < Formula
  desc "GNU data recovery tool"
  homepage "https://www.gnu.org/software/ddrescue/ddrescue.html"
  url "https://ftp.gnu.org/gnu/ddrescue/ddrescue-1.27.tar.lz"
  mirror "https://ftpmirror.gnu.org/ddrescue/ddrescue-1.27.tar.lz"
  sha256 "38c80c98c5a44f15e53663e4510097fd68d6ec20758efdf3a925037c183232eb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f2925686cdea37910494256e583cf01d613f90bb51506dd2b7d29074cd09f40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37b18de8baf95b6bb38e322de59f191e2c50bb0bb0d16c8632e7da177bdad91c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22b84e87b78d58f79c6178b6cc737f22aeb0a92cbe353c1cc156e201e093a242"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8802e7d817f7362a6b17f8eb491b2eb67bd02b4f6234400eb399765f52fa985"
    sha256 cellar: :any_skip_relocation, sonoma:         "313ee83e1e621dcd5d094dc0d9930a5bdb7446538e340002f74b93859a5a4060"
    sha256 cellar: :any_skip_relocation, ventura:        "dfd7d7ccc834e7a36aea13c9d3c9f16c0623acdae03e9d2c9a12ec1cb8b61baf"
    sha256 cellar: :any_skip_relocation, monterey:       "219b2c7be21bd51e52223a3810d820c5d0faf51d0956003bce0181020c7bf98c"
    sha256 cellar: :any_skip_relocation, big_sur:        "94f75c1743efdf6e58d538c8f2ebf324eda5c8e3b23ba5551df89d46bab11c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44cba29aabb794d58f2f3d553f39866dec2821057a7a683ce892ddbb9325c721"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}"
    system "make", "install"
  end

  test do
    system bin/"ddrescue", "--force", "--size=64Ki", "/dev/zero", "/dev/null"
  end
end
