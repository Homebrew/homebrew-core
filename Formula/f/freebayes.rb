class Freebayes < Formula
  desc "Bayesian haplotype-based genetic polymorphism discovery and genotyping"
  homepage "https://github.com/freebayes/freebayes"
  # pull from git tag to get submodules
  url "https://github.com/freebayes/freebayes.git",
      tag:      "v1.3.9",
      revision: "ab36d1f789c039ba872f5d911ce6ff09952dc329"
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

  depends_on "cmake" => :build # for vcflib
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build # for vcflib
  depends_on "simde" => :build
  depends_on "wfa2-lib" => :build # for vcflib
  depends_on "xz" => :build # for vcflib
  depends_on "htslib"

  uses_from_macos "bzip2" => :build # for vcflib
  uses_from_macos "zlib" => :build # for vcflib

  on_macos do
    depends_on "libomp" => :build # for vcflib
  end

  resource "vcflib" do
    url "https://github.com/vcflib/vcflib/releases/download/v1.0.12/vcflib-1.0.12-src.tar.gz"
    sha256 "cb1e78d675f06ae3b22ffed7e1dea317e4c7f826e51e5b5dabd80240efbe1019"

    # Backport fix for using external `wfa2-lib`
    patch do
      url "https://github.com/vcflib/vcflib/commit/5e4edec2fba5d5a51dae7a9fe48d0252ade53857.patch?full_index=1"
      sha256 "e7d6d433d837dd823916ef91fe0165bf4ba4f05c52fd4c9517aef7f80653a2a8"
    end

    # Apply open PR to help find `wfa2-lib` include directory
    # PR ref: https://github.com/vcflib/vcflib/pull/413
    patch do
      url "https://github.com/vcflib/vcflib/commit/9f9237ff0e6b4887f0edfc88587957aa736ced7b.patch?full_index=1"
      sha256 "bede43d22b4b47141cd90edc4df90f65b9ac41e9598c2b05b2fe7fa84ea51aa8"
    end
  end

  # Apply open PR to help Meson locate vcflib and wfa2 libraries
  # PR ref: https://github.com/freebayes/freebayes/pull/822
  patch do
    url "https://github.com/freebayes/freebayes/commit/b458396e1acbad3983c70c202a6db2b3711a8eac.patch?full_index=1"
    sha256 "b5c7d855d4d66c6c96dada307e82ccbf0b6904a25928c4f3e163f52e178b7907"
  end

  # Apply open PR to fix build when using git submodules
  # PR ref: https://github.com/freebayes/freebayes/pull/823
  patch do
    url "https://github.com/freebayes/freebayes/commit/35eeacb6468fdce25233a33f7216f4e776d381f9.patch?full_index=1"
    sha256 "1b6f0bb1e369a4b11e9a7754f3b789035b39cc5d9e3dbbac84fde21893f0d9be"
  end

  def install
    resource("vcflib").stage do
      rm_r(["contrib/WFA2-lib", "contrib/tabixpp/htslib"]) # avoid bundled libraries

      system "cmake", "-S", ".", "-B", "build",
                      "-DBUILD_DOC=OFF",
                      "-DBUILD_ONLY_LIB=ON",
                      "-DZIG=OFF",
                      *std_cmake_args(install_prefix: buildpath/"vendor")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
      system "make", "-C", "contrib/intervaltree", "install", "DESTDIR=", "PREFIX=#{buildpath}/vendor"
      (buildpath/"vendor/include").install "contrib/tabixpp/tabix.hpp"

      ENV.append_path "LIBRARY_PATH", buildpath/"vendor/bin"
      ENV.append_to_cflags "-I#{buildpath}/vendor/include"
      ENV.append_to_cflags "-I#{buildpath}/vendor/include/vcflib"
    end

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
