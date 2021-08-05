class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.12.0.tar.zst"
  version "1.12.0"
  sha256 "8af5d7467c95871c75f857ca3b51e3c015a82a8852fe0769d02fa1dcd9341ae9"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1328ba7ca75ef76ae7d29323d2c59b6b025475c548cb93489776025c6b07ff1d"
    sha256 cellar: :any_skip_relocation, big_sur:       "666734c6443d0cdd28e37af8df1e204fe5ea5ea7dd21d7ec4a0f237ce252b315"
    sha256 cellar: :any_skip_relocation, catalina:      "666734c6443d0cdd28e37af8df1e204fe5ea5ea7dd21d7ec4a0f237ce252b315"
    sha256 cellar: :any_skip_relocation, mojave:        "666734c6443d0cdd28e37af8df1e204fe5ea5ea7dd21d7ec4a0f237ce252b315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8043c769b44e1cbedff262dc985563eb2757f0330b4336b347e46346876b92f5"
  end

  depends_on "go" => :build
  depends_on "zstd" => :build

  def install
    goredo_prefix = "goredo-#{version}"
    system "tar", "--use-compress-program", "unzstd", "-xvf", "#{goredo_prefix}.tar.zst"
    cd "#{goredo_prefix}/src" do
      system "go", "build", *std_go_args, "-mod=vendor"
    end
    cd bin do
      system "./goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
