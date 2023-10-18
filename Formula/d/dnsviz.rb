class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/a5/7c/b38750c866e7e29bc76450c75f61ede6c2560e75cfe36df81e9517612434/dnsviz-0.9.4.tar.gz"
  sha256 "6448d4c6e7c1844aa2a394d60f7cc53721ad985e0e830c30265ef08a74a7aa28"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "0b2d231557e130b430bd55610569b407e8cdafab9787a0d9b859c4498cf7abab"
    sha256 cellar: :any,                 arm64_ventura:  "11ad04a03d99a9398fdda075d4e6752dfe37f5d9d85e1ae236f6e695fe13c6c5"
    sha256 cellar: :any,                 arm64_monterey: "d620d3a8288a84d366393b33036aeab7172529224950e0be2930497ed5acc396"
    sha256 cellar: :any,                 sonoma:         "fb6f201c85ebf633b19204faeea3f370cd1b6676cfa9e0ea229e495267558436"
    sha256 cellar: :any,                 ventura:        "c03ca736dbd690592014dd12f0c20d99ddd3590b7884cc3f503f6c40a760f08c"
    sha256 cellar: :any,                 monterey:       "58c06880a4722d5d2c06074fdca5a6b53f894c7295a5749d4af35d199b73da9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f666d4d7d5a8dfde2e23999de713ca4931129ebfbb5658a1ee8279c4bd2306a"
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "bind" => :test
  depends_on "graphviz"
  depends_on "openssl@3"
  depends_on "python@3.12"

  on_linux do
    # Fix build error of m2crypto, see https://github.com/crocs-muni/roca/issues/1#issuecomment-336893096
    depends_on "swig"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/16/49/bfeaf55da3378292e40e93319717bb4334400e86c00a57fc52677f11fb65/M2Crypto-0.39.0.tar.gz"
    sha256 "24c0f471358b8b19ad4c8aa9da12e868030b65c1fdb3279d006df60c9501338a"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/19/db/cc09516573e79a35ac73f437bdcf27893939923d1d06b439897ffc7f3217/pygraphviz-1.11.zip"
    sha256 "a97eb5ced266f45053ebb1f2c6c6d29091690503e3a5c14be7f908b37b06f2d4"
  end

  def install
    ENV["SWIG_FEATURES"] = "-I#{Formula["openssl@3"].opt_include}"
    virtualenv_install_with_resources(link_manpages: true)
  end

  test do
    (testpath/"example.com.zone.signed").write <<~EOS
      ; File written on Thu Jan 10 21:14:03 2019
      ; dnssec_signzone version 9.11.4-P2-3~bpo9+1-Debian
      example.com.		3600	IN SOA	example.com. root.example.com. (
      				1          ; serial
      				3600       ; refresh (1 hour)
      				3600       ; retry (1 hour)
      				14400      ; expire (4 hours)
      				3600       ; minimum (1 hour)
      				)
      		3600	RRSIG	SOA 10 2 3600 (
      				20230110031403 20190111031403 39026 example.com.
      				D2WDMpH4Ip+yi2wQFmCq8iPWWdHo/vGig/rG
      				+509RbOLHbeFaO84PrPvw/dS6kjDupQbyG1t
      				8Hx0XzlvitBZjpYFq3bd/k0zU/S39IroeDfU
      				xR/BlI2bEaIPxgG2AulJjS6lnYigfko4AKfe
      				AqssO7P1jpiUUYtFpivK3ybl03o= )
      		3600	NS	example.com.
      		3600	RRSIG	NS 10 2 3600 (
      				20230110031403 20190111031403 39026 example.com.
      				bssTLRwAeyn0UtOjWKVbaJdq+lNbeOKBE2a4
      				QdR2lrgNDVenY8GciWarYcd5ldPfrfX5t5I9
      				QwiIsv/xAPgksVlmWcZGVDAAzzlglVhCg2Ys
      				J7YEcV2DDIMZLx2hm6gu9fKaMcqp8lhUSCBD
      				h4VTswLV1HoUDGYwEsjLEtiRin8= )
      		3600	A	127.0.0.1
      		3600	RRSIG	A 10 2 3600 (
      				20230110031403 20190111031403 39026 example.com.
      				TH+PWGhFd3XL09IkCeAd0TNrWVsj+bAcQESx
      				F27lCgMnYYebiy86QmhEGzM+lu7KX1Vn15qn
      				2KnyEKofW+kFlCaOMZDmwBcU0PznBuGJ/oQ9
      				2OWe3X2bw5kMEQdxo7tjMlDo+v975VaZgbCz
      				od9pETQxdNBHkEfKmxWpenMi9PI= )
      		3600	AAAA	::1
      		3600	RRSIG	AAAA 10 2 3600 (
      				20230110031403 20190111031403 39026 example.com.
      				qZM60MUJp95oVqQwdW03eoCe5yYu8hdpnf2y
      				Z7eyxTDg1qEgF+NUF6Spe8OKsu2SdTolT0CF
      				8X068IGTEr2rbFK/Ut1owQEyYuAnbNGBmg99
      				+yo1miPgxpHL/GbkMiSK7q6phMdF+LOmGXkQ
      				G3wbQ5LUn2R7uSPehDwXiRbD0V8= )
      		3600	NSEC	example.com. A NS SOA AAAA RRSIG NSEC DNSKEY
      		3600	RRSIG	NSEC 10 2 3600 (
      				20230110031403 20190111031403 39026 example.com.
      				Rdx/TmynYt0plItVI10plFis6PbsH29qyXBw
      				NLOEAMNLvU6IhCOlv7T8YxZWsamg3NyM0det
      				NgQqIFfJCfLEn2mzHdqfPeVqxyKgXF1mEwua
      				TZpE8nFw95buxV0cg67N8VF7PZX6zr1aZvEn
      				b022mYFpqaGMhaA6f++lGChDw80= )
      		3600	DNSKEY	256 3 10 (
      				AwEAAaqQ5dsqndLRH+9j/GbtUObxgAEvM7VH
      				/y12xjouBFnqTkAL9VvonNwYkFjnCZnIriyl
      				jOkNDgE4G8pYzYlK13EtxBDJrUoHU11ZdL95
      				ZQEpd8hWGqSG2KQiCYwAAhmG1qu+I+LtexBe
      				kNwT3jJ1BMgGB3xsCluUYHBeSlq9caU/
      				) ; ZSK; alg = RSASHA512 ; key id = 39026
      		3600	DNSKEY	257 3 10 (
      				AwEAAaLSZl7J7bJnFAcRrqWE7snJvJ1uzkS8
      				p1iq3ciHnt6rZJq47HYoP5TCnKgCpje/HtZt
      				L/7n8ixPjhgj8/GkfOwoWq5kU3JUN2uX6pBb
      				FhSsVeNe2JgEFtloZSMHhSU52yS009WcjZJV
      				O2QX2JXcLy0EMI2S4JIFLa5xtatXQ2/F
      				) ; KSK; alg = RSASHA512 ; key id = 34983
      		3600	RRSIG	DNSKEY 10 2 3600 (
      				20230110031403 20190111031403 34983 example.com.
      				g1JfHNrvVch3pAX3/qHuiivUeSawpmO7h2Pp
      				Hqt9hPbR7jpzOxbOzLAxHopMR/xxXN1avyI5
      				dh23ySy1rbRMJprz2n09nYbK7m695u7P18+F
      				sCmI8pjqtpJ0wg/ltEQBCRNaYOrHvK+8NLvt
      				PGJqJru7+7aaRr1PP+ne7Wer+gE= )
    EOS
    (testpath/"example.com.zone-delegation").write <<~EOS
      example.com.	IN	NS	ns1.example.com.
      ns1.example.com.	IN	A	127.0.0.1
      example.com.		IN DS 34983 10 1 EC358CFAAEC12266EF5ACFC1FEAF2CAFF083C418
      example.com.		IN DS 34983 10 2 608D3B089D79D554A1947BD10BEC0A5B1BDBE67B4E60E34B1432ED00 33F24B49
    EOS
    system bin/"dnsviz", "probe", "-d", "0", "-A",
      "-x", "example.com:example.com.zone.signed",
      "-N", "example.com:example.com.zone-delegation",
      "-D", "example.com:example.com.zone-delegation",
      "-o", "example.com.json",
      "example.com"
    system bin/"dnsviz", "graph", "-r", "example.com.json", "-Thtml", "-o", "/dev/null"
    system bin/"dnsviz", "grok", "-r", "example.com.json", "-o", "/dev/null"
    system bin/"dnsviz", "print", "-r", "example.com.json", "-o", "/dev/null"
  end
end
