class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.21.0.tar.zst"
  sha256 "87cf36a6dfb165696114b41aaf591f99203332c73031701a8d3e9ecd997d3fc3"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abb4893961d174f43a4b351dc1e4a1e0d2cd4b4eaa405b659d34558d5ae938f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abb4893961d174f43a4b351dc1e4a1e0d2cd4b4eaa405b659d34558d5ae938f2"
    sha256 cellar: :any_skip_relocation, monterey:       "07b2ef200668442f37e3e6d27e602051548d3a14648c7e956c9757439bd4fe66"
    sha256 cellar: :any_skip_relocation, big_sur:        "07b2ef200668442f37e3e6d27e602051548d3a14648c7e956c9757439bd4fe66"
    sha256 cellar: :any_skip_relocation, catalina:       "07b2ef200668442f37e3e6d27e602051548d3a14648c7e956c9757439bd4fe66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10360cf8b7ea61184668050bfbb115e30759000fe648c1cb7cd279db2aa7c295"
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
