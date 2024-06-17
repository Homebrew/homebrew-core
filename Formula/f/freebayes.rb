class Freebayes < Formula
  desc "Bayesian haplotype-based genetic polymorphism discovery and genotyping"
  homepage "https://github.com/freebayes/freebayes"
  url "https://github.com/freebayes/freebayes.git",
      tag:      "v1.3.7",
      revision: "ae60517162d34ab6217bd6c58e2b71551abacac2"
  license "MIT"
  head "https://github.com/freebayes/freebayes.git", branch: "master"

  # The Git repository contains a few older tags that erroneously omit a
  # leading zero in the version (e.g., `v9.9.2` should have been `v0.9.9.2`)
  # and these would appear as the newest versions until the current version
  # exceeds 9.9.2. `stable` uses a tarball from a release (not a tag archive),
  # so using the `GithubLatest` strategy is appropriate here overall.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "86e8ecdd554dd65c305d5c3a4a77199712a9135b0b3fb2c592ace85e725c4d11"
    sha256 cellar: :any, arm64_ventura:  "9f39d67a92d9e832723820b80cb4fa43ba7e2337887ef689fa43340424c77007"
    sha256 cellar: :any, arm64_monterey: "1d03d1fcb588e8e5f96d32c6ad511e46a61712d1a4521623f53ad8b9ded2727b"
    sha256 cellar: :any, sonoma:         "8faa87eff6dcab27a9799df3fb4abbfe7e137db29c6edac31fa91ff65b8d0a37"
    sha256 cellar: :any, ventura:        "dd99fa0c8d6c01e68341e49ff4c13e686661d7d2f33806b00be261f9284ade29"
    sha256 cellar: :any, monterey:       "4379827c288c32cc19ab7aa290b2f724254e3538d2f30288c5f1c3110aee705c"
    sha256               x86_64_linux:   "d2b3b2c133c9f59c8a29a77e5a60b933a63ae83c664b62ddd0802844623a9bc6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    system "meson", "setup", "build", "-Dcpp_std=c++14", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/tiny/.", testpath
    output = shell_output("#{bin}/freebayes -f q.fa NA12878.chr22.tiny.bam")
    assert_match "q\t186", output
  end
end
