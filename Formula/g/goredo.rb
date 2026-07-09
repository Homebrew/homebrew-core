class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.stargrave.org/"
  url "http://www.goredo.stargrave.org/download/goredo-2.9.2.tar.zst"
  sha256 "b15cf99b6d11e586223f24712d90d739e6e115abe4b423d26da9412b90339f41"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.stargrave.org/NEWS.html"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d81a279324994ea6c852dd6bc45717f749a43449c9dc1f0f670bea64a2bf6240"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81a279324994ea6c852dd6bc45717f749a43449c9dc1f0f670bea64a2bf6240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d81a279324994ea6c852dd6bc45717f749a43449c9dc1f0f670bea64a2bf6240"
    sha256 cellar: :any_skip_relocation, sonoma:        "f22082cd19244bc26140bd755706dbfc8e7d4015a8d77c69a33bbcd7f4aea56e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40130e96098f3b230a9078a20f2e99c9bafd40195a00958f35ed0fcf066071ea"
    sha256 cellar: :any,                 x86_64_linux:  "8e64cb8bca78f14f3d6040cb27de1c52bd82e8260c65dc531fd675d258ae77e0"
  end

  deprecate! date: "2026-07-02", because: "is not available via HTTPS"

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
