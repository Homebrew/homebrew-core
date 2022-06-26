class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.25.0.tar.zst"
  sha256 "7044c246fcf6159d84ba7233bc25202baaa08ecccb9c30ca3c26254065eda9a4"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab603e9f86bf997b4837bc93c73340b7e5a4c510c1e3f175a414330b2953e4a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab603e9f86bf997b4837bc93c73340b7e5a4c510c1e3f175a414330b2953e4a8"
    sha256 cellar: :any_skip_relocation, monterey:       "b793b52698e4bf1e6929aadb79b82aa97395d1fe1926d5ce712a427a12f259ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "b793b52698e4bf1e6929aadb79b82aa97395d1fe1926d5ce712a427a12f259ef"
    sha256 cellar: :any_skip_relocation, catalina:       "b793b52698e4bf1e6929aadb79b82aa97395d1fe1926d5ce712a427a12f259ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95ec483d0622bc2be90cfff5c35fc735d2a771c2bc629934ea3c720345177f1f"
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
