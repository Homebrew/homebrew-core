class Hyper < Formula
  desc "Client for the Hyper_ cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
    :tag => "v1.10.8",
    :revision => "8a30254d88bbf9d77aa022a5ba50dbf61c611ad6"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d016a6159483570c471f34ab6a2f86acc8bd4e0f428d792ca5ef6af71758e25" => :sierra
    sha256 "b14e037414fb2dba4efdb78a22ecdc15483d356f9819a8aa333dd83dd01692a5" => :el_capitan
    sha256 "f1da53c767960c35b75458ccc3d98fdd3eaa7a23cb1fe9af00acedc5b366a594" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/hyperhq"
    ln_s buildpath, "src/github.com/hyperhq/hypercli"
    system "./build.sh"
    bin.install "hyper/hyper"
  end

  test do
    system "#{bin}/hyper", "--help"
  end
end
