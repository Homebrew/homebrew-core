class Cdsclient < Formula
  desc "Tools for querying CDS databases for astronomical data"
  homepage "https://cdsarc.u-strasbg.fr/doc/cdsclient.html"
  url "https://cdsarc.u-strasbg.fr/ftp/pub/sw/cdsclient-4.07.tar.gz"
  sha256 "4a0a02cb1dc48bc9a0873ebb3ef9b031f9288baf13a3573f885a8504f9c317c5"
  license "GPL-3.0-only"

  # This directory listing page also links to `python-cdsclient` tarballs, so
  # we have to use a stricter regex (instead of the usual `href=.*?`).
  livecheck do
    url "https://cdsarc.u-strasbg.fr/ftp/pub/sw/"
    regex(/href=["']?cdsclient[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47fd63a71583aeb84d0624a2d5914cb6e20c2364bc906d4da8263f583024c59a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0523647ffcb98339e8c9f2424d20afa561ae87caf6734eea0142439b9a655397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9a0d2c2f3822aa4a2c23f64d1921c3bd2c3f25d64004ad90868f9ccc303cef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce712b39898660b3b383ecbb7cea31aac7681fb14980982f99c3b59cc5d130dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8a738375e2a386b461f29a111dbb0da50e05ab784af7e07b588553a2bf9b759"
    sha256 cellar: :any_skip_relocation, ventura:       "4fc95c54e491a0973791f1f741d6a5e4a1190147c3d404d99f9fdb90f7a35d4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b2b835d82cb1b820e6e01b5b797c1ca9bedd08ebff78c1c85ae58951fe6ad95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "244a0d04795c89d1e51cdd4b671bf438c0698bb1177555122403cfa4c071079d"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}"
    man.mkpath
    system "make", "install", "MANDIR=#{man}"
    pkgshare.install bin/"abibcode.awk"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/catcat VIII/59/ReadMe")
      VIII/59             the FIRST Survey, version 1999Jul   (White+ 1999)
    EOS

    assert_match "Usage: lscat CDS-catalogue(s)", shell_output("#{bin}/lscat 2>&1", 1)
  end
end
