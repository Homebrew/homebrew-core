class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.21.tar.gz"
  sha256 "19a96b95a1c22da9d812014660744c6a31aac597b53ac17128068a77c269cde8"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a6f936f6411b77ae9a337573b8515cd812fc5a1531f8f23e5b81f67cf6746a6" => :catalina
    sha256 "b29839aecb3c2baccaea03af66504fe993fa590dda06d608b40ffb64697d0125" => :mojave
    sha256 "d267b22108f0174da30e56d8d1346b9d581c0ab98a48885c1c5e668368c47598" => :high_sierra
    sha256 "d267b22108f0174da30e56d8d1346b9d581c0ab98a48885c1c5e668368c47598" => :sierra
    sha256 "d267b22108f0174da30e56d8d1346b9d581c0ab98a48885c1c5e668368c47598" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end

  test do
    system sbin/"fetch-crl", "-l", testpath
  end
end
