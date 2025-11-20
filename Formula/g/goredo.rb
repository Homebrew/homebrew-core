class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.su/"
  url "http://www.goredo.cypherpunks.su/download/goredo-2.6.5.tar.zst"
  sha256 "16c5f14d448357af32c782b2537c41afa71f9dca071c480107686e110bf92a3f"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.su/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38f4e36b4edd7896604d65d110cfd156b003af812bc4c1b4936cc02b9ecfe5ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f4e36b4edd7896604d65d110cfd156b003af812bc4c1b4936cc02b9ecfe5ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38f4e36b4edd7896604d65d110cfd156b003af812bc4c1b4936cc02b9ecfe5ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "234adde9e392625fe7c50958f910c198dafe59b43326bc2032338c894b84107c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3320fbce03518905aea61104d8eec7b9c77498551fb1fddac6996181f2e55e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449c9ea9edae7787733c328e092f5f2626c82aa23de099ec112be07563fa8e02"
  end

  depends_on "go" => :build

  conflicts_with "redo", because: "both install `redo` and `redo-*` binaries"

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"
    end

    ENV.prepend_path "PATH", bin
    cd bin do
      system "goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_match "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")

    assert_match version.to_s, shell_output("#{bin}/goredo -version")
  end
end
