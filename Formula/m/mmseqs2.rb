class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/refs/tags/17-b804f.tar.gz"
  version "17-b804f"
  sha256 "300ebd14bf4e007b339037e5f73d8ff9c4e34f8495204c4a8c59c7672b689db2"
  license "MIT"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d6e60b4dab916c2783b876db9af4351b6a2a8db35a4bcd566e14ad897b2cdd30"
    sha256 cellar: :any,                 arm64_sonoma:  "48f4da646306654a7ba6e6a7a08f8a023a57468544f3e7586f55d1b10379e6bd"
    sha256 cellar: :any,                 arm64_ventura: "5ff54b4b1996f420d1bc76d40ca69748a3e51ffb9da937abaf73488bfe2c13d2"
    sha256 cellar: :any,                 sonoma:        "6f417d8a97a1fccbfedef502bbdf2fc35d1c1635f1f0343f85f230e2fac34654"
    sha256 cellar: :any,                 ventura:       "411080f71627445783e1333574c5de1cbe9a41b3852fc5eeaa693efb8de1d4e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d996d17e951ff3ce554fff2f1eaf834220b35ac4991b566ef078ae90bad3b40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fc3d695d1c1db71311cf2c0306d7affdc088ff445618970413c896b641a210c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gawk"
  end

  # `git ls-remote https://github.com/soedinglab/MMseqs2.wiki.git HEAD`
  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "b1ccffcaf6be0f857e37670a260311f2416b6794"
  end

  def install
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DHAVE_TESTS=0
      -DHAVE_MPI=0
      -DVERSION_OVERRIDE=#{version}
    ]

    args << if Hardware::CPU.arm?
      "-DHAVE_ARM8=1"
    else
      "-DHAVE_SSE4_1=1"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  def caveats
    on_intel do
      "MMseqs2 requires at least SSE4.1 CPU instruction support." unless Hardware::CPU.sse4?
    end
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/soedinglab/MMseqs2/releases/download/12-113e3/MMseqs2-Regression-Minimal.zip"
      sha256 "ab0c2953d1c27736c22a57a1ccbb976c1320435fad82b5c579dbd716b7bae4ce"
    end

    resource("homebrew-testdata").stage do
      ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
      system "./run_regression.sh", "#{bin}/mmseqs", "scratch"
    end
  end
end
