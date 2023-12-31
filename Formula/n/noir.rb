class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/noir-cr/noir"
  url "https://github.com/noir-cr/noir/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "25660741e04a7c4e617fcb1fbfdbb85568665b13126325bde58545dffda7a935"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "65a453315181de7bdff8e9c8fb1b8eb1b35448e32c2b3705e70bbe419a8ec8a3"
    sha256 arm64_ventura:  "d8ae269aa95daa33eb369afeb57640246613e369aac730c61c22d3ab87f890b3"
    sha256 arm64_monterey: "811bfd0fb1b96ef9bef35de0609087fd1c405f77c9c3965c2943e5a54146cf40"
    sha256 sonoma:         "9a41267eb4bfd6f3a6bee70dcfe917d138322348066a47cc3bdd330f71389a31"
    sha256 ventura:        "42d1c99bc8a609d2771cd8d138159c3d8e8f96187bb98000fbaf88b193f8133d"
    sha256 monterey:       "7ee7561d3ed30001eaa9b1987bc93d3ef4c7cf2f3aeaf315b5890b5868d03cb8"
    sha256 x86_64_linux:   "d3cf110bcba845ad07c06bcb2d9dfc21f1f1b45ac4f2771dfb471d3f8796f16e"
  end

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/noir-cr/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
