class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz"
  sha256 "17cf76943de272fd579ed831a1fd85339b393f8d00bf9e0d17c91e972f583343"

  bottle do
    cellar :any
    sha256 "19ab6da7a72cc00ead3f9511462b2f18d8f2e00a95da849e85fd53101b744539" => :high_sierra
    sha256 "9e915cdec5a6848d987a4bff2f5137ca1cf3aad9844461da4b08bf9f30b96b87" => :sierra
    sha256 "1ba8ee5699bf4dde9e728d3138af3b7bd5d6811065cdd2ad9c398dffbd38c30d" => :el_capitan
    sha256 "cdc073935379e4c2e14a5e98c7d16a4a6303d2682b9d77ed8addee555bdd9354" => :yosemite
    sha256 "c974bd4f5515644268c6f9ff13bb392508d6148bc22be8f5fc2da3afe1fa6c89" => :mavericks
    sha256 "3fe3f4737cee1d27465100119dc9f194a985cc8ec1f4a55cecb45d7669c04484" => :mountain_lion
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
