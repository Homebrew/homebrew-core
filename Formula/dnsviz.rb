class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://files.pythonhosted.org/packages/a5/7c/b38750c866e7e29bc76450c75f61ede6c2560e75cfe36df81e9517612434/dnsviz-0.9.4.tar.gz"
  sha256 "6448d4c6e7c1844aa2a394d60f7cc53721ad985e0e830c30265ef08a74a7aa28"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "56c68dbe7136d4dd190c8f4ca523dc3874f655aba5be6212f266758491d73b8d"
    sha256 cellar: :any,                 arm64_big_sur:  "e70c11a9ccb3daf97c76cab2632520d2abac3678dd5712cba719e67d921e65cb"
    sha256 cellar: :any,                 monterey:       "b80d337b9793d9de352301d1822278bff183099924dd36e920db62e4a8bba78c"
    sha256 cellar: :any,                 big_sur:        "dfff42e474d4c0e7f26d2a87161f85478646745d2528fcffb38859401f1b6e6b"
    sha256 cellar: :any,                 catalina:       "4323bcd148cdada2c26229d2bc0b9b63236d5ba4e1cae635272a7a599cfbd9d4"
    sha256 cellar: :any,                 mojave:         "5580679f91243fb6d6823f2ba1d55e468983734e9753f94e70c455bd70c3b072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf7082822faac8b00a75851f4a2d8577cf9a8d4371d8a2d231c719cae612202"
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
    url "https://files.pythonhosted.org/packages/99/fb/e7cd35bba24295ad41abfdff30f6b4c271fd6ac70d20132fa503c3e768e0/dnspython-2.2.1.tar.gz"
    sha256 "0f7569a4a6ff151958b64304071d370daa3243d15941a7beedf0c9fe5105603e"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/2c/52/c35ec79dd97a8ecf6b2bbd651df528abb47705def774a4a15b99977274e8/M2Crypto-0.38.0.tar.gz"
    sha256 "99f2260a30901c949a8dc6d5f82cd5312ffb8abc92e76633baf231bbbcb2decb"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/c7/21/063c3ec261904f3c67b7d8bb0033e4e53bbdacb17e6d27097239d50fb7ca/pygraphviz-1.9.zip"
    sha256 "fa18f7c6cea28341a4e466ed0cf05682b0a68288afe8dd7c9426782f7c1ae01c"
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
