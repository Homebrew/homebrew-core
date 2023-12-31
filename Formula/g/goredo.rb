class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-2.6.0.tar.zst"
  sha256 "5d32ffa2d7c2282e794ec501055a2bb3692016938587eea87a438e69f3a1714b"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66464a51e212eb5784de4db6950a4beb48859f9eff4f49b1ea232eb73dd1cb4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3519d2c0435edb9903e46fbadf35f0639e84259704b3cd8a95512430b2e2807b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22f41a76fb36c5b5fe85d8fd682e238b6e17ab4134c3e75b8469ef4fda15ebd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "238dcd82d59ea75409b37d6e39a969b0056d763285d18f598397b0c8c149844c"
    sha256 cellar: :any_skip_relocation, ventura:        "0b5eb0389da544ae161969cb10f218aa3f662c8980fb605f0ac0cbc5d878371f"
    sha256 cellar: :any_skip_relocation, monterey:       "0926b01aeff120103a532bc99914b2d4c59eef793b933c90cce1e66eb2066661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec967e5148c4eebc06df1551d919e18c6e2fa17c8908b24ff775e76940a23ce"
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
