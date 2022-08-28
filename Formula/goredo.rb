class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.27.0.tar.zst"
  sha256 "63cfdb24f14ec7071b5bb8ed237023410826ea9f21d48e8e6c9f43ae2af34176"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894817277a6c7b2353ca5b0e09b913e1320aaa4e648ec021fcaa3ab6e588b713"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "894817277a6c7b2353ca5b0e09b913e1320aaa4e648ec021fcaa3ab6e588b713"
    sha256 cellar: :any_skip_relocation, monterey:       "86f130e01e4d025cf4e776567a6e710a0e6ba23e13ce64226b9a2c26321ca791"
    sha256 cellar: :any_skip_relocation, big_sur:        "86f130e01e4d025cf4e776567a6e710a0e6ba23e13ce64226b9a2c26321ca791"
    sha256 cellar: :any_skip_relocation, catalina:       "86f130e01e4d025cf4e776567a6e710a0e6ba23e13ce64226b9a2c26321ca791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82eb4e2c5cf77d467e6be634405070fb7a475124329e7af7ec7b5a13a76c7bc9"
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
