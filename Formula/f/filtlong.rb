class Filtlong < Formula
  desc "Quality filtering of long noisy DNA sequencing reads"
  homepage "https://github.com/rrwick/Filtlong"
  url "https://github.com/rrwick/Filtlong/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "09b43a0c9e2c6b40cd29e3025de8ff39302c0b5eabbf660a47c9c26bdf9dd35e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee42060b9b7c55d85d703e19b39270f2d1b687c7f57573424c901aad58562c19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb9cfb3edfa804f810a3180c00a7358f4a06e8bd396c8ac2036d4df53056fe02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0b8388b17425d31657d46c00975946c5f4bd67199d8fb14dadd09847c18b928"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bf5298a7376a553572588d8249c59b10996d70ae797aaf48dc069282b4ef671"
    sha256 cellar: :any,                 arm64_linux:   "baeeb1875799f337c988e667b4b3d5398e2668f19299c847c2abeee657d516f8"
    sha256 cellar: :any,                 x86_64_linux:  "b658541b14b15f775f74b3f509dbffece3ac4a4d9cdabe1ca4ac69301fbd4074"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "bin/filtlong"
    pkgshare.install "test"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filtlong --version 2>&1")
    system bin/"filtlong", "--min_length", "1000", pkgshare/"test/test_trim.fastq"
  end
end
