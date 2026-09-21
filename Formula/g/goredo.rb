class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.stargrave.org/"
  url "http://www.goredo.stargrave.org/download/goredo-2.10.0.tar.zst"
  sha256 "9229effbd8add272b489af12d96f0037c156cb575137d9cdcd5786f27e1a6364"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.stargrave.org/NEWS.html"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d67a49a7555f7797076e24614bf9901396de5f742a80b26426f6f85beeb01b20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36503cf2f5036178d3adf9b5a78285a19962f72e73df28ff6de1e951ee62e66f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36503cf2f5036178d3adf9b5a78285a19962f72e73df28ff6de1e951ee62e66f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "36503cf2f5036178d3adf9b5a78285a19962f72e73df28ff6de1e951ee62e66f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1aa3e1bb57ffa051bcddb71117624c49b74045112b7aed165868eb81e0c57938"
    sha256 cellar: :any,                 x86_64_linux:      "abf6f8cacc7c40a2e012aff2cbd86fdabe49c8c3778f9bd162ce622e0c0e9808"
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
