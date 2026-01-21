class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.su/"
  url "http://www.goredo.cypherpunks.su/download/goredo-2.8.0.tar.zst"
  sha256 "7aaab717697b1c15f24164122f80e769a82a6a157b01a6590365c749d326bd06"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a9b1660695595402615e05a83aa7fdb7542387dffad6fdc251bfd7b1569e3d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a9b1660695595402615e05a83aa7fdb7542387dffad6fdc251bfd7b1569e3d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a9b1660695595402615e05a83aa7fdb7542387dffad6fdc251bfd7b1569e3d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1379cfc82524903f892c4108535ac3eb74577adef265275df880f0d7ba44bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d427a1c2fb0cbab8edb36e9378324d938e09c00e214ad0aac0eca221ee3ad1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e538694b61f3e59d986cdc13616c9f3388d44ca6be1dd063a2d4fba5452d9ec9"
  end

  deprecate! date: "2026-01-05", because: "is not available via HTTPS"

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
