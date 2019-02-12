class Dnsviz < Formula
  include Language::Python::Virtualenv

  desc "Tools for analyzing and visualizing DNS and DNSSEC behavior"
  homepage "https://github.com/dnsviz/dnsviz/"
  url "https://github.com/dnsviz/dnsviz/releases/download/v0.8.1/dnsviz-0.8.1.tar.gz"
  sha256 "b62e6642aba46cf145f9ca23d02fcfd101752a7448d1b44537334ddc4e359eae"

  bottle do
    cellar :any
    rebuild 1
    sha256 "aad7a8e4c5908badd46f5450efbf420c2270ff2455f2d8e440e65ea67064e73e" => :mojave
    sha256 "f4ac015b79e1329a97501daa011570de89cf10ccfaff6c711336515efc11b406" => :high_sierra
    sha256 "33cb4ee29142ae28d442e37dc4df4cb0c659a1734ad83777682b909d008151ca" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "bind" => :test
  depends_on "graphviz"
  depends_on "libsodium"
  depends_on "openssl"
  depends_on "python@2"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/7e/b1/d6d849ddaf6f11036f9980d433f383d4c13d1ebcfc3cd09bc845bda7e433/pygraphviz-1.5.zip"
    sha256 "50a829a305dc5a0fd1f9590748b19fece756093b581ac91e00c2c27c651d319d"
  end

  resource "m2crypto" do
    url "https://files.pythonhosted.org/packages/0a/d3/ecef6a0eaef77448deb6c9768af936fec71c0c4b42af983699cfa1499962/M2Crypto-0.31.0.tar.gz"
    sha256 "fd59a9705275d609948005f4cbcaf25f28a4271308237eb166169528692ce498"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/bf/9b/2bf84e841575b633d8d91ad923e198a415e3901f228715524689495b4317/typing-3.6.6.tar.gz"
    sha256 "4027c5f6127a6267a435201981ba156de91ad0d1d98e9ddc2aa173453453492d"
  end

  def install
    venv = virtualenv_create(libexec)
    resource("m2crypto").stage do
      system libexec/"bin/python", "setup.py", "build_ext", "--openssl=#{Formula["openssl"].opt_prefix}", "install"
    end
    venv.pip_install resources.reject { |r| r.name == "m2crypto" }
    system libexec/"bin/python", "setup.py", "build"
    system libexec/"bin/python", "setup.py", "install", "--prefix=#{libexec}", "--install-data=#{prefix}", "--install-scripts=#{bin}"
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
