class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/cd/6e/8e285523108cc91b32f0584c2b4a7b006348af597cdc84e728206df15b3b/dnsviz-0.10.0.tar.gz"
  sha256 "8e2c4d0636296acf704f7eca1ca8fea98b022c920c5517b39dfdc982ce685cd3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "010d753c953f5784dbdcabb3a0e178b37feebc15a8849ecc60da0e06e6b1a98d"
    sha256 cellar: :any,                 arm64_ventura:  "11074313d53d5f0e1bb3bb45e5f0d2cfd360890158bb0db237acfb5fdac8b4a6"
    sha256 cellar: :any,                 arm64_monterey: "4cb91ae29fff849510d2eab470bcfe4370158db481f9ce11101661a692ff1855"
    sha256 cellar: :any,                 sonoma:         "d16f6e37ee84a64ed3dd280965879b0d103dd67b1330842d61b5bb3502cd526e"
    sha256 cellar: :any,                 ventura:        "be79adbc4298d749b20aa5d3f223a80bab1ebb58cac17a5ee5bbb89d7449a1ea"
    sha256 cellar: :any,                 monterey:       "6ed049efc4d975a5eff8cdfb85e2f23274d73e9218e9b4bf4ce4822f04d96c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80fb24e908cb98fc30a35d3a4a882daa73eaa9c1b9678a4ec714f3118e42450c"
  end

  depends_on "bind" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "json-c" => :test
  depends_on "graphviz"
  depends_on "openssl@3"
  depends_on "python@3.12"

  on_linux do
    # Fix build error of m2crypto, see https://github.com/crocs-muni/roca/issues/1#issuecomment-336893096
    depends_on "swig"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "m2crypto" do
    url "https://files.pythonhosted.org/packages/d7/7d/2b414ab83ae8d1e1eb4e8c255f94a8424d41e975f97b25da82f4029f78d2/M2Crypto-0.41.0.tar.gz"
    sha256 "3a1358c7ee849046d91782a777f1786bf027a1c1d51b5faf8f19435bfc3f1495"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/8c/41/7b9a22df38bb7884012b34f2986d765691dbe41bf5e7af881dfd09f8145f/pygraphviz-1.13.tar.gz"
    sha256 "6ad8aa2f26768830a5a1cfc8a14f022d13df170a8f6fdfd68fd1aa1267000964"
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
