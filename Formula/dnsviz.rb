class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/1f/76/c64f7b445d5a869a65c633ff9f5c04c8d72a75a5ca11e9a18fd104edfaf8/dnsviz-0.9.3.tar.gz"
  sha256 "6f38f3d71b2b9ca3f4cffb003c828574d0c413bcc5112bb52921fa9db4e69259"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3db7cc32c451761409b59b1ee15b41b46392892ba76859a4f48b1029216b15bb"
    sha256 cellar: :any, big_sur:       "5f8ab0c06c72486bfaee86b789c15482ecae3a78ecc6912c4986aff5d3bb8819"
    sha256 cellar: :any, catalina:      "b4a5a0647e673fb99c41a261bddd92c0b1d601ba539d18cfe1ae9a9abd0e2037"
    sha256 cellar: :any, mojave:        "05b5c37f1c92e3992e27b6348097bb11234ae934e0fa3c797d745987b2c8d6ea"
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "bind" => :test
  depends_on "graphviz"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  on_linux do
    # Fix build error of m2crypto, see https://github.com/crocs-muni/roca/issues/1#issuecomment-336893096
    depends_on "swig"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/13/27/5277de856f605f3429d752a39af3588e29d10181a3aa2e2ee471d817485a/dnspython-2.1.0.zip"
    sha256 "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/aa/36/9fef97358e378c1d3bd567c4e8f8ca0428a8d7e869852cef445ee6da91fd/M2Crypto-0.37.1.tar.gz"
    sha256 "e4e42f068b78ccbf113e5d0a72ae5f480f6c3ace4940b91e4fff5598cfff6fb3"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/3a/d6/2c56f09ee83dbebb62c40487e4c972135661b9984fec9b30b77fb497090c/pygraphviz-1.7.zip"
    sha256 "a7bec6609f37cf1e64898c59f075afd659106cf9356c5f387cecaa2e0cdb2304"
  end

  def install
    ENV["SWIG_FEATURES"]="-I#{Formula["openssl@1.1"].opt_include}"

    virtualenv_install_with_resources
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
    system "#{bin}/dnsviz", "probe", "-d", "0", "-A",
      "-x", "example.com:example.com.zone.signed",
      "-N", "example.com:example.com.zone-delegation",
      "-D", "example.com:example.com.zone-delegation",
      "-o", "example.com.json",
      "example.com"
    system "#{bin}/dnsviz", "graph", "-r", "example.com.json", "-Thtml", "-o", "/dev/null"
    system "#{bin}/dnsviz", "grok", "-r", "example.com.json", "-o", "/dev/null"
    system "#{bin}/dnsviz", "print", "-r", "example.com.json", "-o", "/dev/null"
  end
end
