class Kallisto < Formula
  desc "Quantify abundances of transcripts from RNA-Seq data"
  homepage "https://pachterlab.github.io/kallisto/"
  url "https://github.com/pachterlab/kallisto/archive/refs/tags/v0.51.1.tar.gz"
  sha256 "a8bcc23bca6ac758f15e30bb77e9e169e628beff2da3be2e34a53e1d42253516"
  license "BSD-2-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eb1aea233d5290b68ece9eea3fd31675586b2605dadaa7037f4b9ab1a72bf26f"
    sha256 cellar: :any,                 arm64_sequoia: "f655f79f72630cbd72d17a0e655b520a92ae8758baa74d93d75a40ff5040d2dc"
    sha256 cellar: :any,                 arm64_sonoma:  "230fe2322f4c8cc7cef85e1ed0498d4405c725e793fd375e4774ceaf2585e2c0"
    sha256 cellar: :any,                 sonoma:        "c8db8ebf3fa7797363e0f46e26a4de458f76130d7512e794b9e7dc78ec80ae88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bcbc6e7a0390a11a375772067fa935370bd81344f7619738180b2760201b253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1629b0f197520096e048911ae289bd77334b14eefbf1f50167990713b63024"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix compilation error in Bifrost
  # https://github.com/pachterlab/kallisto/issues/488
  patch do
    url "https://github.com/pmelsted/bifrost/commit/d228b532a2cd5d3a598092ea4c46d1e997e50737.patch?full_index=1"
    sha256 "75ae03575fc1ab9826504ec297d2b424fe779dae6e9edebdeaf78a8a8b4e55cd"
    directory "ext/bifrost"
  end

  def install
    # Fix to error: unsupported option '-mno-avx2'
    inreplace "ext/bifrost/CMakeLists.txt", "-mno-avx2", ""

    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    ENV.deparallelize

    # Workaround to build with CMake 4
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    system "cmake", "-S", ".", "-B", "build", "-DUSE_HDF5=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >seq0
      FQTWEEFSRAAEKLYLADPMKVRVVLKYRHVDGNLCIKVTDDLVCLVYRTDQAQDVKKIEKF
    EOS

    output = shell_output("#{bin}/kallisto index -i test.index test.fasta 2>&1")
    assert_match "has 1 contigs and contains 32 k-mers", output
  end
end
