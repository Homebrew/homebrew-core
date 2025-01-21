class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.6.8.tar.gz"
  sha256 "ad4846a0eb4a8247e9893f42a8ab2b89750a0fea060d60626684746bf511f6a4"
  license "MIT"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e31284aa5a98b58e16e21a16a32910389309f8f175839b68abc2e8980065daa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b1830e6d9bf7cb92867dc1c8abd048ba562b52cd61a19bbd4c83092366b4aba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "738e10caadb7b08a52202b86353cc13bbc04b81df5413e5146a85afb9c88546a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11f1d8417345ff5b60f9eae4098b894246cb29ac7199f397f86db7a3c235dfd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "7baa0958b2bf84ba3725381f05741aaa4f6c1c620ee3c6887451d0e3aa8be0fc"
    sha256 cellar: :any_skip_relocation, ventura:        "78180c749974f3df237f9436b8d2f87f5e31b834ecd564d6b83ce54cc860774a"
    sha256 cellar: :any_skip_relocation, monterey:       "c88568646b14a09092425cf09120b09f0996af5bede89c448ea3fb9949c08ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63ae702046e2330da0ecebbd379c191bf3edf69a3e1e374b281ffffea42b44aa"
  end

  def install
    system "make"
    bin.install "deark"
  end

  test do
    require "base64"

    (testpath/"test.gz").write ::Base64.decode64 <<~EOS
      H4sICKU51VoAA3Rlc3QudHh0APNIzcnJ11HwyM9NTSpKLVfkAgBuKJNJEQAAAA==
    EOS
    system bin/"deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
