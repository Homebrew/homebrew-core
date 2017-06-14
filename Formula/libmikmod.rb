class Libmikmod < Formula
  desc "Portable sound library"
  homepage "http://mikmod.shlomifish.org"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.11/libmikmod-3.3.11.tar.gz"
  sha256 "d1ba23ce8191ac917f9080bbc1e5e879887c01acd7bd311b1315932c4312abea"

  bottle do
    cellar :any
    sha256 "582942e61825e40addb1cdfbd46e8bfbcb5efb061422bc521eae206927ff0786" => :sierra
    sha256 "524fbb83a324427ca140a58370ff28658b33251a58aab6c54c126ec227bb77d8" => :el_capitan
    sha256 "e9ca13cb39d2d615e0efd03bb68ec9bfb3e70af4d7e4ad3d971ccccd80520ccf" => :yosemite
  end

  option "with-debug", "Enable debugging symbols"

  def install
    ENV.O2 if build.with? "debug"

    # macOS has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    args = %W[
      --prefix=#{prefix}
      --disable-alsa
      --disable-sam9407
      --disable-ultra
    ]
    args << "--with-debug" if build.with? "debug"
    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
