class Freebayes < Formula
  desc "Bayesian haplotype-based genetic polymorphism discovery and genotyping"
  homepage "https://github.com/freebayes/freebayes"
  url "https://github.com/freebayes/freebayes/releases/download/v1.3.6/freebayes-1.3.6-src.tar.gz"
  sha256 "6016c1e58fdf34a1f6f77b720dd8e12e13a127f7cbac9c747e47954561b437f5"
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
    sha256 cellar: :any, arm64_monterey: "26799da3d54c7416f8c79cbc95ab4c7428cc60a3d5dba0d4f67e08050cd7d40c"
    sha256 cellar: :any, arm64_big_sur:  "3045a4eb949197230993c9ddfb92406978b410d8beb18b401465867c8481ddff"
    sha256 cellar: :any, monterey:       "00aeab78a22a3edd81add014b529383ec3deb49c6addb71c8319e5e5abe54a64"
    sha256 cellar: :any, big_sur:        "63f3fcc4d0811b6077b5cd302e624220b736eaa0b2198e4f09df26d10cddf47d"
    sha256 cellar: :any, catalina:       "3d38d37c49642117c959ce76ccf4653c77b779650f00c89839dbce0a8d7ea509"
    sha256               x86_64_linux:   "7196ad033d4f6565b5603fdfc113f9d00f69873b32b7b46a44c6625bb133c9e0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/tiny/.", testpath
    output = shell_output("#{bin}/freebayes -f q.fa NA12878.chr22.tiny.bam")
    assert_match "q\t186", output
  end
end
