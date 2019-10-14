class Bubbros < Formula
  desc "The Bub's Brothers: Clone of the famous Bubble Bobble game"
  homepage "https://bub-n-bros.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bub-n-bros/bub-n-bros/1.6.2/bubbros-1.6.2.tar.gz"
  sha256 "0ad8a359c4632071a9c85c2684bae32aa0fa278632c49f092dc4078cfb9858c4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0787da9180d41eb01bca38a6e0c04759877e5c141d9dd1de02c3e81ebc6ad771" => :catalina
    sha256 "40db40b8456691091963eeb5e7183a79dfa392c3428261b582b29f1201398163" => :mojave
    sha256 "e808145d3d1ae843d32a437be1ef8ad70c837bf4b2ccf66e4963cd6561d45c14" => :high_sierra
    sha256 "afee50e9fa76478ba416a51cae53efa3ac6ff9fd457d58fb5b6b0b09d343e4c9" => :sierra
    sha256 "989c2af93a6acef698f8e02dbed8c7a282a550cec60aba5b4029db830dcbeff1" => :el_capitan
  end

  depends_on "python@2" # does not support Python 3

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

  test do
    system "#{bin}/bubbros-client --help; test $? -eq 2"
    system "#{bin}/bubbros-server --help; test $? -eq 1"
  end
end
