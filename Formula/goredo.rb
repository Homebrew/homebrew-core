class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.22.0.tar.zst"
  sha256 "f501e2da8024f96521adacc68863c7b9fe7a9d9413de662190b7d72eeddcbe20"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77ce1b6c009d57866d26594dddead756a742eefa1859f5562d7571688fa85471"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77ce1b6c009d57866d26594dddead756a742eefa1859f5562d7571688fa85471"
    sha256 cellar: :any_skip_relocation, monterey:       "d7253ca2f6fe7c6536079260c806c134971527a89456cf3ee50b3d000e27bda9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7253ca2f6fe7c6536079260c806c134971527a89456cf3ee50b3d000e27bda9"
    sha256 cellar: :any_skip_relocation, catalina:       "d7253ca2f6fe7c6536079260c806c134971527a89456cf3ee50b3d000e27bda9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1514410583c1e7ce537d0681a89add537d6b913fcfc5c62bec7f23e0a5181561"
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
