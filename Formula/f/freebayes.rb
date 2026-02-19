class Freebayes < Formula
  desc "Bayesian haplotype-based genetic polymorphism discovery and genotyping"
  homepage "https://github.com/freebayes/freebayes"
  # pull from git tag to get submodules
  url "https://github.com/freebayes/freebayes.git",
      tag:      "v1.3.10",
      revision: "b0d8efd9fa7f6612c883ec5ff79e4d17a0c29993"
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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "6ac99ac74405aba54f7b65a2b36ca561ba46b5566829dc1c2b9758cc8be12aca"
    sha256 cellar: :any, arm64_sequoia: "514ae73cd4c7187fd2bbcbb18ac5f6f688ac03f389e7ec93c50fc29136f2c5be"
    sha256 cellar: :any, arm64_sonoma:  "7c97223f0041563242414bd68dc319fd288d7521add1d8f87671f98f8ba79c64"
    sha256 cellar: :any, sonoma:        "1a6e217f03bd2122f3ef8ab00c72ae7780018794ffb8dc67972760dd2b3bf727"
    sha256               arm64_linux:   "4eba699d3f1534639286e3b1f8b5aa3dad87a474bff7d99a92c35a6298f2d3df"
    sha256               x86_64_linux:  "9bff5501fddada4a471d2b1d8580bf71e7dbf7ad405ca7b7381ae3050bd6e775"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "simde" => :build
  depends_on "wfa2-lib" => :build
  depends_on "htslib"
  depends_on "tabixpp"

  resource "intervaltree" do
    url "https://github.com/ekg/intervaltree/archive/refs/tags/v0.1.tar.gz"
    sha256 "7ba41f164a98bdcd570f1416fde1634b23d3b0d885b11ccebeec76f58810c307"

    # Fix to error: ‘numeric_limits’ is not a member of ‘std’
    patch do
      url "https://github.com/ekg/intervaltree/commit/aa5937755000f1cd007402d03b6f7ce4427c5d21.patch?full_index=1"
      sha256 "7ae1070e3f776f10ed0b2ea1fdfada662fcba313bfc5649d7eb27e51bd2de07b"
    end
  end

  def install
    inreplace "meson.build" do |s|
      # add contrib to include directories
      s.gsub! "incdir = include_directories(", "incdir = include_directories('contrib',"

      # add tabixpp to library directories, https://github.com/mesonbuild/meson/issues/8091
      s.gsub! "find_library('tabixpp'", "\\0, dirs: '#{Formula["tabixpp"].opt_lib}'"
    end

    # install intervaltree
    (buildpath/"contrib/intervaltree").install resource("intervaltree")

    # Set prefer_system_deps=false as we don't have formulae for these and some are not versioned/tagged
    system "meson", "setup", "build", "-Dcpp_std=c++14", "-Dprefer_system_deps=false", *std_meson_args
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
