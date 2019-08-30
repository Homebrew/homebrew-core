class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.18.tar.gz"
  sha256 "5481cd5d8dbacd39d0c531a68ae8afcca3160c808770d66dcbf5e9b5be3e8199"
  revision 1

  bottle do
    cellar :any
    sha256 "a7e3e6db73182a40a2b6363a019aaa96b6e02d4cb9b3d3ce243df9428ff9bb51" => :mojave
    sha256 "64dd6cf3f86dd311d55917cd3aae5d75880c6ee5e5f30523f560276f853631a7" => :high_sierra
    sha256 "c0479f4ee597d863dd66b86ffc0f1ff1f7c4deba568c9077cea7b9938a4e17ad" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python"

  def install
    args = %w[
      --enable-s3
      --enable-python
      --disable-fuse
    ]

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *args
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
  end
end
