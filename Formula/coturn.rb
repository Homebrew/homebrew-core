class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.0.6/turnserver-4.5.0.6.tar.gz"
  sha256 "c0ff3224084ff9a9504147a7b87431ee815ebeea0de7c7cb67126859da7e25a6"

  bottle do
    sha256 "7703a16ab5ef734b03f8142c819438d9b6b05aa642cd0ff442a933848ff7af41" => :sierra
    sha256 "3c386fc7eb7720a2a366c2655069e1ed005ac0428503a866a5f467bfa97e80df" => :el_capitan
    sha256 "b67ccadf14f63f7b6d266b79b6fce5410f891459a5252a83537de1f3e57e3982" => :yosemite
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
