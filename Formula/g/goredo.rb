class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-2.0.0.tar.zst"
  sha256 "b914629354b87b47a3530dfe4a308e252794f8cc611e3d47cec06c8e7782f9e4"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a0f8c43d77c46ec5b132fab539205fc7152b3a8194651a88e7684b810650928"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4111694f8f334ec1f2cb87fe9d9ef29fa8970abfc3e3d7b7ff7b58cc2530b46f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d92fd940692827bb4db533d6b517e7528e423cbd353babde91cadb181c05d67e"
    sha256 cellar: :any_skip_relocation, sonoma:         "83e72d76ecca31fbe15447560941124c2836639c2237fae013254335366a13e4"
    sha256 cellar: :any_skip_relocation, ventura:        "2e5e793f6424c6215e7397f738d2a39354c2fcb0aae2ebb7ac0588a55702990d"
    sha256 cellar: :any_skip_relocation, monterey:       "cc04e3f20e75a800a3e8f43be14f6a04a8df154c9802adeae45e242a44a94206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "179be28466cc4e96cacaae89ac934c355571f9ebc5fbb7342171e3cdb7d9f4cb"
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
