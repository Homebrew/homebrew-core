class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/3.0.0.tar.gz"
  sha256 "8728a823709bc39c7aecd29ee19508816accbaa27dfd15933fe1fa2e2cf1fcd7"
  license "GPL-2.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "df471847ca4cad96821c296f0b2fcb30622c0284498cef72f8bd6486d183fe52" => :big_sur
    sha256 "f38b9f04ac49b301c599a497b2c4cbc562bc2fcfb73db76ba787fa10d185be76" => :catalina
    sha256 "df70a9f7bb60eb8c65ed1b7ef6d850f3c2d57321e9be3e814c2480edac3c89df" => :mojave
    sha256 "8e1168b64a282ce94ded17806bd16142920411f9515f17cd5bb7ed1eb272635c" => :high_sierra
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
