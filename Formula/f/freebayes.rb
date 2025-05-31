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
    sha256 cellar: :any, arm64_sequoia: "33af05be5ee1447351c87cc4619116ce170e8859ff0533c070f346fb2f6eca8b"
    sha256 cellar: :any, arm64_sonoma:  "315f293a526bef59d1c63f8f4f4fb27783852f19dfaa20218131d4604523a22f"
    sha256 cellar: :any, arm64_ventura: "c29719f1990607011ef77722f0059255652d721641ba57ffa1fc1d7effed0bdc"
    sha256 cellar: :any, sonoma:        "7d68eca383a04fae9434a48205c7548bb02a6ec9e1f511645e69c33959e35a4e"
    sha256 cellar: :any, ventura:       "2b5efeb60159a49524d33c803581815a4005afe972a4c3cb102d04ce91b7120e"
    sha256               arm64_linux:   "21666bea0fedab514f5f8af83515d9389e475fe5dc6bf7d0dd73a99ce51e768e"
    sha256               x86_64_linux:  "8b76cc3e3db9575510c456b74286a1f5732e5495b3c1232311a2c0c220fc7e0f"
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
