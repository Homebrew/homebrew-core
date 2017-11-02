class IrssiXmpp < Formula
  desc "Irssi plugin to connect to the Jabber network"
  homepage "https://cybione.org/~irssi-xmpp/"
  url "https://github.com/cdidier/irssi-xmpp/archive/v0.54.tar.gz"
  sha256 "1033cc6bf03abaacdb083e1fbe7d75d8a62622339e06d889422d8f0705fa7776"
  head "https://github.com/cdidier/irssi-xmpp.git"

  depends_on "glib"
  depends_on "irssi"
  depends_on "loudmouth"
  depends_on "pkg-config" => :build

  def install
    ENV.prepend "LDFLAGS", "-flat_namespace -undefined warning"
    ENV["PREFIX"] = prefix
    ENV["IRSSI_INCLUDE"] = Formula["irssi"].include/"irssi"
    system "make", "install"
  end

  def caveats; <<~EOS
    To load the plugin add:
      /load #{opt_prefix}/lib/irssi/modules/libxmpp
    to your ~/.irssi/startup
    EOS
  end

  test do
    system "true"
  end
end
