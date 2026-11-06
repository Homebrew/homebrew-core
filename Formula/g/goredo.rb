class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.stargrave.org/"
  url "http://www.goredo.stargrave.org/download/goredo-2.11.0.tar.zst"
  sha256 "53fd8d48ff80a936b697dae515924a59c80fe9709dbad5a952ba79303951359b"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.stargrave.org/NEWS.html"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e59caecdd28d474af08ef5f6d3273a1df98aa3b40e19acd6c9c970a8450710e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e59caecdd28d474af08ef5f6d3273a1df98aa3b40e19acd6c9c970a8450710e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e59caecdd28d474af08ef5f6d3273a1df98aa3b40e19acd6c9c970a8450710e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "89fa10d426d6068525ac89e539d91562ca0c046b12f75a86ae6369967abc374a"
    sha256 cellar: :any,                 x86_64_linux:      "6925048b1e4a31169f0decdde9f45f9c682dbabdf35045c2314f810b36adcac3"
  end

  deprecate! date: "2026-07-02", because: "is not available via HTTPS"

  depends_on "go" => :build

  conflicts_with "redo", because: "both install `redo` and `redo-*` binaries"

  deny_network_access!

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
    assert_match "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")

    assert_match version.to_s, shell_output("#{bin}/goredo -version")
  end
end
