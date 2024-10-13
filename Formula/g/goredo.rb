class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.su/"
  url "http://www.goredo.cypherpunks.su/download/goredo-2.6.2.tar.zst"
  sha256 "5663ed0da911f1b2c0d13e92cc06ede3738639edb48499eb9e53d38e8e435d75"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.su/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc4ef66c53328a68a74eaf8a9175e6bdfc99771776881c5ef8edce16a9594fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc4ef66c53328a68a74eaf8a9175e6bdfc99771776881c5ef8edce16a9594fcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc4ef66c53328a68a74eaf8a9175e6bdfc99771776881c5ef8edce16a9594fcb"
    sha256 cellar: :any_skip_relocation, sonoma:        "df9cdf7553d9dc649ab23cf622ae38e37437d2b46e6b48cc989bd7342f528c3e"
    sha256 cellar: :any_skip_relocation, ventura:       "df9cdf7553d9dc649ab23cf622ae38e37437d2b46e6b48cc989bd7342f528c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aab40b938c60be8e24bc8c03cd21ed59324b84902ddfe032075a55e65a889f7"
  end

  depends_on "go" => :build

  conflicts_with "redo", because: "both install `redo` and `redo-*` binaries"

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
