class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-2.2.0.tar.zst"
  sha256 "89f19c52dd7786b4124a161b1807426a0dc13cf2d730553957de3bcf252d982f"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a77f647fe279c95697b62daf45bc70f00400c93005fae388f6ca5e588d83f1cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af1d6ede9514a8d9ce245f2d1e845b2c07c4430cd779a4d9135ef6fecbc71986"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d232ea2d68b3ca4ed9431af8defaa9a5aeffb9b6ce638e8f846272a352f7d548"
    sha256 cellar: :any_skip_relocation, sonoma:         "40b9949f79764e4c2ac5407176380d78e6e2a2cae7981f6daed5270f43921a66"
    sha256 cellar: :any_skip_relocation, ventura:        "2c4a4d781c29a4b0640b29f911ea531c35a17eaa4acc399947e67fd5e6c520a0"
    sha256 cellar: :any_skip_relocation, monterey:       "607d8dfd59dba3500117af5ad3469e2290004801386822d00097bfb9ffbbfc76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12676b8305b40385e7db2c78fee6730df3cd2d5de7e1170f8d3df51c92c7dc60"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"
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
    assert_match "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")

    assert_match version.to_s, shell_output("#{bin}/goredo -version")
  end
end
