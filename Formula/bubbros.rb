class Bubbros < Formula
  desc "The Bub's Brothers: Clone of the famous Bubble Bobble game"
  homepage "https://bub-n-bros.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bub-n-bros/bub-n-bros/1.6.2/bubbros-1.6.2.tar.gz"
  sha256 "0ad8a359c4632071a9c85c2684bae32aa0fa278632c49f092dc4078cfb9858c4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d2351400c225202caf19dbd0d712da7fe32e0db3a8f29c5d933a60e44961a2f3" => :high_sierra
    sha256 "672afb435affe29227d9755b9c06b787263506059f27e9470c98e8fd7119d9a9" => :sierra
    sha256 "f9e5eb52706a72f8a6999e30945a5ab89035c1a9dbff403a8febd68322f56124" => :el_capitan
    sha256 "66e1a809c1e27df455cfb0f25a2c5b1d3a4560ef9598c2c2a4b6ffce66f9b591" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on :x11 => :optional

  # Patches from debian https://sources.debian.net/patches/bubbros
  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/replace_sf_logo.patch"
    sha256 "f984c69efeb1b5052ef7756800e0e386fc3dfac03da49d600db8a463e222d37f"
  end

  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/config_in_homedir.patch"
    sha256 "2474b4438fb854a29552d5ddefd17a04f478756ea0135b4298b013d9093a228f"
  end

  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/disable_runtime_image_building.patch"
    sha256 "e96f5233442a54a342409abe8280f2a735d447e9f53b36463dfc0fcfaef53ccb"
  end

  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/manpages.patch"
    sha256 "ad0bd9b7f822e416d07af53d6720f1bc0ce4775593dd7bd84f3cdba294532f50"
  end

  patch do
    url "https://sources.debian.net/data/main/b/bubbros/1.6.2-1/debian/patches/remove_shabangs.patch"
    sha256 "99ab1326b4b5267fb6c7bdb85b84e184126aa21099bffbedd36adb26b11933db"
  end

  def install
    system "make", "-C", "bubbob"
    system "make", "-C", "display" if build.with? :x11
    system "python", "bubbob/images/buildcolors.py"

    man6.install "doc/BubBob.py.1" => "bubbros.6"
    man6.install "doc/Client.py.1" => "bubbros-client.6"
    man6.install "doc/bb.py.1" => "bubbros-server.6"

    prefix.install Dir["*"]

    bin.mkpath
    (bin/"bubbros").write shim_script("BubBob.py")
    (bin/"bubbros-client").write shim_script("display/Client.py")
    (bin/"bubbros-server").write shim_script("bubbob/bb.py")
  end

  def shim_script(target); <<~EOS
    #!/bin/bash
    cd "#{prefix}"
    python "#{target}" "$@"
    EOS
  end

  def caveats
    s = <<~EOS
      The Shared Memory extension of X11 display driver is not supported.
      Run the display client with --shm=no
        bubbros-client --shm=no
    EOS
    s if build.with? :x11
  end

  test do
    system "#{bin}/bubbros-client --help; test $? -eq 2"
    system "#{bin}/bubbros-server --help; test $? -eq 1"
  end
end
