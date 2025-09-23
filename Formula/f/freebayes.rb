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
    sha256 cellar: :any, arm64_tahoe:   "6c56a131cdd190ae3ca497c0bb7289b6433ee8476b2fabcabd87c6237eb8ca2d"
    sha256 cellar: :any, arm64_sequoia: "fe3551f272a78c35e210c171b28a89f3d21ccf8d9bf7ca8e6754880c3d228e55"
    sha256 cellar: :any, arm64_sonoma:  "0a3d8fe813c8e97ded11ea118bc911eabe1268978384c8258311eee2c8faff58"
    sha256 cellar: :any, arm64_ventura: "e7cf7f62a74dc67a7da26bb0de4c61235564ed4319da0e068562f5259636b056"
    sha256 cellar: :any, sonoma:        "f4cff84f549d2e6b9b40e2ab84ae82ed07fe5b7da2b7673f0f5679f9d0b93d09"
    sha256 cellar: :any, ventura:       "2bc50a5d6aac51804c8c7a12145660f09c7e68c453e43206e371335209ca0cd6"
    sha256               arm64_linux:   "c076ac85a630648c4972beb9c1db024a5753fb877621c7222a91546e6d0d5773"
    sha256               x86_64_linux:  "6b15a1010ab2db38829e674e191ed2ac8a78b579ee1c4c3f8b9fbe33285c3133"
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
    # add contrib to include directories
    inreplace "meson.build", "incdir = include_directories(", "incdir = include_directories('contrib',"

    # install intervaltree
    (buildpath/"contrib/intervaltree").install resource("intervaltree")
    # add tabixpp to include directories
    ENV.append_to_cflags "-I#{Formula["tabixpp"].opt_include} -L#{Formula["tabixpp"].opt_lib} -ltabix"

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
