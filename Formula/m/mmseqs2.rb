class Mmseqs2 < Formula
  desc "Software suite for very fast sequence search and clustering"
  homepage "https://mmseqs.com/"
  url "https://github.com/soedinglab/MMseqs2/archive/refs/tags/18-8cc5c.tar.gz"
  version "18-8cc5c"
  sha256 "3541b67322aee357fd9ca529750d36cb1426aa9bcd1efb2dc916e35219e1a41c"
  license "MIT"
  head "https://github.com/soedinglab/MMseqs2.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "db5b603365d96e19fb686f87657965c7920368c9972ba4df890e015db5a62242"
    sha256 cellar: :any,                 arm64_sequoia: "9e54025ebe34f6c6183dea51234b59d36603c6095894e8a16970b0998452556a"
    sha256 cellar: :any,                 arm64_sonoma:  "9acef9a8874241678098c1132be15aa1df6fd2a6a709ea4f2a98e850bafda29b"
    sha256 cellar: :any,                 sonoma:        "32b6bd0d7785c60cd96c2012eafe53ef3bae20d12487d4bb57f1b906f0a95be1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "093b602dad229d6adfc9860a347118d837c0c21e2a7489f7ae49cefe5432ae9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1078e3ad9bea79349ebb08e136c4581cc4edd7e095961ae8f4b6ad412d35cd5"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "wget"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gawk"
    depends_on "zlib-ng-compat"
  end

  # `git ls-remote https://github.com/soedinglab/MMseqs2.wiki.git HEAD`
  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        revision: "67ba9c6637b4b5121a73e5de034dd0c3414d2b81"
  end

  def install
    args = %W[
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
