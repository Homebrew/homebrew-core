class Bubbros < Formula
  desc "The Bub's Brothers: Clone of the famous Bubble Bobble game"
  homepage "http://bub-n-bros.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bub-n-bros/bub-n-bros/1.6.2/bubbros-1.6.2.tar.gz"
  sha256 "0ad8a359c4632071a9c85c2684bae32aa0fa278632c49f092dc4078cfb9858c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "54b93573f8d5de0b51eafc9b0c6a2bc4f1d2530b1f31923cf9fcd95a0a098838" => :sierra
    sha256 "072b7e03df1d5dbe8ce6e1d8c23251bb3358e3d6106f88f6fb0425142ab7afdc" => :el_capitan
    sha256 "6166d83051609c8e9e9a7001a0e75b57e2166a2f93d74194f2d7455581270531" => :yosemite
  end

  depends_on :python
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

  def shim_script(target); <<-EOS.undent
    #!/bin/bash
    cd "#{prefix}"
    python "#{target}" "$@"
    EOS
  end

  def caveats
    s = <<-EOS.undent
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
