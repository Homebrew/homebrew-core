class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.27.1.tar.zst"
  sha256 "98c1a8a189b33753fcd61e1dbdbe627dba3820621d2032a3856d89829eea08d9"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72fdb9979827d1a2e83968eacf73844854779c01f2997c0591140b2ef2b11a3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72fdb9979827d1a2e83968eacf73844854779c01f2997c0591140b2ef2b11a3f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ead552451a32aba5db24d0508c030cd13ed80349addcdf160a9dc81361b543b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ead552451a32aba5db24d0508c030cd13ed80349addcdf160a9dc81361b543b"
    sha256 cellar: :any_skip_relocation, catalina:       "6ead552451a32aba5db24d0508c030cd13ed80349addcdf160a9dc81361b543b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82b1b94bef0967f49755ce0947727e12c66438bc27ec896b3d905c76a0cf28ae"
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
