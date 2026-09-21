class Libmikmod < Formula
  desc "Portable sound library"
  homepage "https://mikmod.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.14/libmikmod-3.3.14.tar.gz"
  sha256 "dffd82b8f254c3489c32098da831f33eac7136843d1e7ccb802f1254ad5b4219"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libmikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c6f768219823da4363752c82bcc17171eb810853c8f3e6412075516e0e5f343"
    sha256 cellar: :any, arm64_tahoe:       "f5153327273854ae91d744b6d2f9bbeb6e176aecd3b94426c607233d13d1fd0b"
    sha256 cellar: :any, arm64_sequoia:     "cf44cad43a8afa8fb0d0123372b31c296f995c5621e51ebfd9db524cf8201806"
    sha256 cellar: :any, arm64_linux:       "8b499b751acae0b7b95ada2f1e0f163cb44ec1c7802a080ee1641e1622652339"
    sha256 cellar: :any, x86_64_linux:      "4f35ddbdf67db4fcb2a146e5fea1c06d3202ced78d1f4c3bde84eaa8efcbf6ea"
  end

  def install
    mkdir "macbuild" do
      # macOS has CoreAudio, but ALSA, SAM9407 and ULTRA are not supported
      system "../configure", "--prefix=#{prefix}", "--disable-alsa",
                             "--disable-sam9407", "--disable-ultra"
      system "make", "install"
    end
  end

  test do
    system bin/"libmikmod-config", "--version"
  end
end
