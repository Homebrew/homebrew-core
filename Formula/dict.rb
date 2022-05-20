class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.13.1/dictd-1.13.1.tar.gz"
  sha256 "e4f1a67d16894d8494569d7dc9442c15cc38c011f2b9631c7f1cc62276652a1b"
  license "GPL-2.0"

  bottle do
    sha256 arm64_monterey: "78b07272ca6147d7bf00f0952d2c5a9692fd2de372d850e0ce3aed8f2acffc1d"
    sha256 arm64_big_sur:  "e09d115b6d78be9f257b943de096aa09ae616733776e9b9e9825f1124cb8da4e"
    sha256 monterey:       "360dfa6fe899696ef4ddda448bdd904348dd02f147c3a0f5b7433c894773d214"
    sha256 big_sur:        "04cd15245ebd92063b552cc04a92cb5fa888ef9b1dbaeb3199abe3d3a68d8e0b"
    sha256 catalina:       "da4b9f76b6e3bb5d18f5ac0abe43dea7dd4f571f9e41686ff45b3945ecd40e9a"
    sha256 x86_64_linux:   "dc56eeb450b3ce327f27d2ef1ca74c74e2e3e0b3c28ed6cae1c0543ad736a148"
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix+"etc/dict.conf").write <<~EOS
      server localhost
      server dict.org
    EOS
  end
end
