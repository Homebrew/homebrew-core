class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.su/"
  url "http://www.goredo.cypherpunks.su/download/goredo-2.6.4.tar.zst"
  sha256 "0e53b444a6eb9c5a13088cd680e2e697a5a0e059710c1ad8e30879fe9dc0770c"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.su/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6b8f202aa96cefec546d73380b45f523cb7d5064e8aea5cc7e1ecbd948b0629"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6b8f202aa96cefec546d73380b45f523cb7d5064e8aea5cc7e1ecbd948b0629"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6b8f202aa96cefec546d73380b45f523cb7d5064e8aea5cc7e1ecbd948b0629"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9154b4746a01f2088c2d9ff5159d83ea61a95ef709b2bca64ea4d2a0c0c6ac0"
    sha256 cellar: :any_skip_relocation, ventura:       "d9154b4746a01f2088c2d9ff5159d83ea61a95ef709b2bca64ea4d2a0c0c6ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37604c5f3eec8a5def60149db7563234b654211925dd997ce2a016a5cc70ac5"
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
