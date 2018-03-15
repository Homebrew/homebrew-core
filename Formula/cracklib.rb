class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz"
  sha256 "17cf76943de272fd579ed831a1fd85339b393f8d00bf9e0d17c91e972f583343"

  bottle do
    sha256 "c7f22644746f0ea3abb20e772625b633ab8a73f0f773b57baa7d71a3620b367c" => :high_sierra
    sha256 "d7d9452c277c47b1a7ad681a08c48f1e7ee5db4c9745520d271eb7f3a6f32757" => :sierra
    sha256 "4e16e0eefb0560fab07c517fa54a6c79d77f989b725adff642c9c496c2879b25" => :el_capitan
  end

  depends_on "gettext"

  # Upstream commit from 25 Aug 2016 "Apply patch to fix CVE-2016-6318"
  patch :p2 do
    url "https://github.com/cracklib/cracklib/commit/47e5dec.patch?full_index=1"
    sha256 "8b9d455525fb967813cc51cb82eff637d608ba5578e59abd3c7290b5892d2708"
  end

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-words-2.9.6.bz2"
    sha256 "460307bb9b46dfd5068d62178285ac2f70279e64b968972fe96f5ed07adc1a77"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words"
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match /password: it is based on a dictionary word/, pipe_output("#{bin}/cracklib-check", "password", 0)
  end
end
