class Afio < Formula
  desc "Creates cpio-format archives"
  homepage "https://github.com/kholtman/afio"
  url "https://github.com/kholtman/afio/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "c64ca14109df547e25702c9f3a9ca877881cd4bf38dcbe90fbd09c8d294f42b9"
  # See afio_license_issues_v5.txt
  license :cannot_represent
  head "https://github.com/kholtman/afio.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f5c6e7fd1928e44f9b105d46afbe6615590f0021e16ca4332c71122e913f06dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d2aff60d7ee0309043a8a16fcc08fa31e97f926e891e0cba31fe0f68968f2ae5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1827985d86c7da8918f35afafdd8cc7bf62fe20e8ebc627cdd77c7ac12b2ab0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "181059011f90205cc99df3760661b795b59cda42e7bf18746403889e6305ac65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b4f681e5f0c0d32afa17e1f68c74b510ad922996f0bea0ce8be409169047e20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca63097a9d1a29c00ae8a799941e937c7359b9df59c723b6110cd7b5cfe7c943"
    sha256 cellar: :any_skip_relocation, sonoma:         "450bd133db30e618eb5f538bf3f4c740c08f74abf26037356bd629148f20edde"
    sha256 cellar: :any_skip_relocation, ventura:        "9e5718d3fe605e90aa5bd956bf4849274d716f09617c10da3d3bb522dea23d24"
    sha256 cellar: :any_skip_relocation, monterey:       "f01da50d10c66c547df1cbaafd07131eb1307737d5e8556c85da1741b1c8c056"
    sha256 cellar: :any_skip_relocation, big_sur:        "0daf7df23f36271e3141cc11cab067b33ed5855b9faba53bc697d5259deb82ca"
    sha256 cellar: :any_skip_relocation, catalina:       "28494133d10acea2c1a298fe858d26889ba8567422b9f431710b156a4a8ac858"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8a697f6c0f0e1fd2b2fca0db9d4eacb4e12dbb0f82212fbe00947bca01c3eea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93dee32378176bea139dadf874fed07b411076443fee3a7ff33c84eadfc7760d"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "DESTDIR=#{prefix}"
    bin.install "afio"
    man1.install "afio.1"

    prefix.install "ANNOUNCE-2.5.1" => "ANNOUNCE"
    prefix.install %w[INSTALLATION SCRIPTS]
    share.install Dir["script*"]
  end

  test do
    path = testpath/"test"
    path.write "homebrew"
    pipe_output("#{bin}/afio -o archive", "test\n", 0)

    system bin/"afio", "-r", "archive"
    path.unlink

    system bin/"afio", "-t", "archive"
    system bin/"afio", "-i", "archive"
    assert_equal "homebrew", path.read.chomp
  end
end
