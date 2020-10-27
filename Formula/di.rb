class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.48.tar.gz"
  sha256 "19d549feb59ccde7ff1cd2c48fea7b9ba99fa2285da81424603e23d8b5db3b33"
  license "Zlib"

  livecheck do
    url :homepage
    regex(%r{<p>Current Version: v?(\d+(?:\.\d+)+)</p>}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c49db9fca46dd848d4cf5badc22524ab66f8169c6368a7839023b3593969f451" => :catalina
    sha256 "e3ba587be02153b3fc475ffe3dfc21714ce0e82e9a4d03d32e9ecaff4400e287" => :mojave
    sha256 "14522350f027f600e28be34b412ba66ab95c1fcbbce81dd064826493165aa142" => :high_sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
