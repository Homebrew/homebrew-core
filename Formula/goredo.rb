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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a54e5956587bb0935526aed8b52deb0a533e1dc90dc4a098120ba20b451c03b"
    sha256 cellar: :any_skip_relocation, big_sur:       "184e7bc44254c0f3e5f74fe5de0115c7bb0a5d0043dff4c8951512b32f60ef20"
    sha256 cellar: :any_skip_relocation, catalina:      "184e7bc44254c0f3e5f74fe5de0115c7bb0a5d0043dff4c8951512b32f60ef20"
    sha256 cellar: :any_skip_relocation, mojave:        "184e7bc44254c0f3e5f74fe5de0115c7bb0a5d0043dff4c8951512b32f60ef20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de59a39ab519b8a94f5a6dcfd24c3bf4c9c227dd0a48576b66367edddadfaf26"
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
