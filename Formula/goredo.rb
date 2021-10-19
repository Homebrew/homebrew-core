class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.17.0.tar.zst"
  sha256 "9105ad351cadce37ad5c994dc7a334862c1269c37de5eae5a59b7b2238bdff1d"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88bf64e8fec0c7d5bf1868100898022f4639296013327765d5f436483e71ffd4"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9553151466c628a1c2dc431b870f77e6e9383d1e84b1bb492a6107bf7928100"
    sha256 cellar: :any_skip_relocation, catalina:      "c9553151466c628a1c2dc431b870f77e6e9383d1e84b1bb492a6107bf7928100"
    sha256 cellar: :any_skip_relocation, mojave:        "c9553151466c628a1c2dc431b870f77e6e9383d1e84b1bb492a6107bf7928100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76c03f2bc2ff67a84a9ea6f963fdba1ca174e535db0bed21e1c59180487802f0"
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
