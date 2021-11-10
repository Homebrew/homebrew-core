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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08462f798e167495b6b83ee89f715b26d45f05988b2a70600ebce48492d1b7fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08462f798e167495b6b83ee89f715b26d45f05988b2a70600ebce48492d1b7fd"
    sha256 cellar: :any_skip_relocation, monterey:       "900299993b3c679f257c2e27cd53c1ab3f949c4990d92332454e0db3a01f24ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "900299993b3c679f257c2e27cd53c1ab3f949c4990d92332454e0db3a01f24ce"
    sha256 cellar: :any_skip_relocation, catalina:       "900299993b3c679f257c2e27cd53c1ab3f949c4990d92332454e0db3a01f24ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10bc347cbc72eeba6f97f4ce337985299860189f4d638b70cb15c5807a2923a4"
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
