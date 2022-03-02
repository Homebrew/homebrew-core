class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.24.0.tar.zst"
  sha256 "656e96d9f3efa45f035c2dd096fa91763854dbf1a09a37409c25ffc25cbc358f"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f99456a16ae5496c2e542217ec9795aae6f89f7372457b01fe8e09b0d3bff1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5f99456a16ae5496c2e542217ec9795aae6f89f7372457b01fe8e09b0d3bff1"
    sha256 cellar: :any_skip_relocation, monterey:       "1bc231d2c10e5fdbcc7d9dfbd878714770d2c1a8823093f3d216131bc128ea64"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bc231d2c10e5fdbcc7d9dfbd878714770d2c1a8823093f3d216131bc128ea64"
    sha256 cellar: :any_skip_relocation, catalina:       "1bc231d2c10e5fdbcc7d9dfbd878714770d2c1a8823093f3d216131bc128ea64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96830b5bd88dbdcb26bd5bd31e2abf7e0eb3ea65d710c89b3c683d8bef2aee4b"
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
