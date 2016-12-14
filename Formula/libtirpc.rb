class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "http://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.0.1/libtirpc-1.0.1.tar.bz2"
  sha256 "5156974f31be7ccbc8ab1de37c4739af6d9d42c87b1d5caf4835dda75fcbb89e"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c093d0948f7794df11cae0a0f0e974e8b0734d46beb2f7977db39d84aa16720" => :x86_64_linux
  end

  depends_on "homebrew/dupes/krb5" => :optional unless OS.mac?

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end
end
