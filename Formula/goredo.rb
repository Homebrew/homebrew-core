class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.27.1.tar.zst"
  sha256 "98c1a8a189b33753fcd61e1dbdbe627dba3820621d2032a3856d89829eea08d9"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b099f496182028da2e24068200c2adfdd1fdaed332249f1d7ca5784e89de78c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b099f496182028da2e24068200c2adfdd1fdaed332249f1d7ca5784e89de78c9"
    sha256 cellar: :any_skip_relocation, monterey:       "324cee2aa32865c07842e9af63af9f1aed3e2d901373388d9e245e7330281d23"
    sha256 cellar: :any_skip_relocation, big_sur:        "324cee2aa32865c07842e9af63af9f1aed3e2d901373388d9e245e7330281d23"
    sha256 cellar: :any_skip_relocation, catalina:       "324cee2aa32865c07842e9af63af9f1aed3e2d901373388d9e245e7330281d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea76612012bce7e674d5e05dc5848e8798ce9f93e795d7a218efb2446f66613b"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args, "-mod=vendor"
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
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
