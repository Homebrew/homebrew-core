class Dxflib < Formula
  desc "C++ library for parsing DXF files"
  homepage "https://www.ribbonsoft.com/en/what-is-dxflib"
  url "https://www.ribbonsoft.com/archives/dxflib/dxflib-3.17.0-src.tar.gz"
  sha256 "26c5acfb55150c5fc5d4b35f21582824845628bea9a893e7fcf71c83e07fd227"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "db45aa2b00f82b996370eaf1321e0cce79fc3868c42a9524e10adce478139bc2" => :sierra
    sha256 "aff6c3f5e5bca552c5962e8ef5c43d1dd5fb0630d091e206a164e99ed8b70637" => :el_capitan
    sha256 "e883aa60c9baab1198671db178c0723e4331ed9fb65ad4d87ba72ca921d7d0b4" => :yosemite
    sha256 "0e591fba7cac298bf4afbb4d7f9895c10865998c6ae64ad4db31c7a33c3377cc" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
