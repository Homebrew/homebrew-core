class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.22.0.tar.gz"
  sha256 "60a4bafad93ab03bf44e7f0c1e726fad715742eb9bbdd32fae33c78fe452dc65"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    sha256 "6ed2c5e3acd529bd1346efd569b64ebe8f1ec8e26172023514268bf03d04ff23" => :mojave
    sha256 "78333529ad9b34ca9b17e0bea3dee0a5193f65c472c448712bb6b51f6d611efa" => :high_sierra
    sha256 "44d70bc0cac39828c7da58c3c2b8c239368ca7b0cb938343cd5b56e49580c98a" => :sierra
    sha256 "e1e8201b171ef0122b21373abea31968ba5b74a69374c9bd208059389420c323" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    dir = build.head? ? "testing/geckodriver" : "."
    cd(dir) { system "cargo", "install", "--root", prefix, "--path", "." }
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
