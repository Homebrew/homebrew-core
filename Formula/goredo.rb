class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.19.0.tar.zst"
  sha256 "7566e933ea0b6aeba91070a36a0a088d7e70b48dcd34fb470b2f37984abd87da"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecc58979bd9e7ecd7c6c1c3f5bb4ebc02c18dc8fea9a788abea238d06558e311"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecc58979bd9e7ecd7c6c1c3f5bb4ebc02c18dc8fea9a788abea238d06558e311"
    sha256 cellar: :any_skip_relocation, monterey:       "b04ccb951cf8996c18be2e35a7d4cc1981a18e6bb678b5647b48a1fdd4e4ef19"
    sha256 cellar: :any_skip_relocation, big_sur:        "b04ccb951cf8996c18be2e35a7d4cc1981a18e6bb678b5647b48a1fdd4e4ef19"
    sha256 cellar: :any_skip_relocation, catalina:       "b04ccb951cf8996c18be2e35a7d4cc1981a18e6bb678b5647b48a1fdd4e4ef19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4e356b2ce03f66e057b6f7b3cd8ebc293234c7c0ff33cb921d36b080c3524d"
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
