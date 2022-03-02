class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.24.0.tar.zst"
  sha256 "656e96d9f3efa45f035c2dd096fa91763854dbf1a09a37409c25ffc25cbc358f"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621663018e6545716224d74de28bfbf120e1e966a179eec79f2d2df6593cfafa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "621663018e6545716224d74de28bfbf120e1e966a179eec79f2d2df6593cfafa"
    sha256 cellar: :any_skip_relocation, monterey:       "83095d1338fd7635c831647924338f4e61d905270e1566b1128f27bbfa0b41ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "83095d1338fd7635c831647924338f4e61d905270e1566b1128f27bbfa0b41ea"
    sha256 cellar: :any_skip_relocation, catalina:       "83095d1338fd7635c831647924338f4e61d905270e1566b1128f27bbfa0b41ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ad54f1956ca9ec95dcc74e616fd19802515c5e06b24742616c9bb231e36123"
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
