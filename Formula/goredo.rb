class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.30.0.tar.zst"
  sha256 "825b20daaf2315de33e82b8ace567769f271fd2ec0c3a2c2c45012fee1cb9548"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "860d264e7da00f9186612ffc5676a0a4820bafa675bb1fbf1169d7cd54227cf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860d264e7da00f9186612ffc5676a0a4820bafa675bb1fbf1169d7cd54227cf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "860d264e7da00f9186612ffc5676a0a4820bafa675bb1fbf1169d7cd54227cf7"
    sha256 cellar: :any_skip_relocation, ventura:        "671716ac14ebaf83fed0c3bf0009ab1cbbf2708e8110a42afd3a169fd9387220"
    sha256 cellar: :any_skip_relocation, monterey:       "671716ac14ebaf83fed0c3bf0009ab1cbbf2708e8110a42afd3a169fd9387220"
    sha256 cellar: :any_skip_relocation, big_sur:        "671716ac14ebaf83fed0c3bf0009ab1cbbf2708e8110a42afd3a169fd9387220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "225d9779916a4d3a0301ee8964ec59fb98992d41068972559ecb11a7a8a58d69"
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
