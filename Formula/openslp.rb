class Openslp < Formula
  desc "Implementation of Service Location Protocol"
  homepage "http://www.openslp.org"
  url "https://downloads.sourceforge.net/project/openslp/2.0.0/2.0.0%20Release/openslp-2.0.0.tar.gz"
  sha256 "924337a2a8e5be043ebaea2a78365c7427ac6e9cee24610a0780808b2ba7579b"

  bottle do
    sha256 "fdd847dba24e5a96c30ccef98f0d035f39abc88617d779df627c132be5b648ae" => :sierra
    sha256 "1c19d8355ddda63b9259101a0b7b56ea0fd9fb8f343e2df19f7248542fbf38e5" => :el_capitan
    sha256 "95e41f7f42e80ab3234b460d90196389a0d275877195fe188ffc6249c0b762ce" => :yosemite
    sha256 "883203d7fc5bbd6faefa058bf2f68dad2cc6a485f46599163d000684ae585507" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
