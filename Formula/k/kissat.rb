class Kissat < Formula
  desc "Bare metal SAT solver"
  homepage "https://github.com/arminbiere/kissat"
  url "https://github.com/arminbiere/kissat/archive/refs/tags/rel-4.0.4.tar.gz"
  sha256 "bfe93eaa6323b48011e4b1fcf74b3f2e20f9de544767e728009e5b2018296193"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67e49c44458a442a6ccadbf16e9cf7ef419d22ac1d2fe2dd3f9a0e7c8c2ffb77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b66a3192b73682075386abda2c27a6318b6a7f3364ef3cb2803624f3719833d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fcaeae9f5035f8273ae2809bbdee818e7d3c2c160f19eb02c7953bd3d16f2ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "36eb3d024cbf5940ec33db9b59897ded7591b19981427caaa5d29f52da453706"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21fcc0a15aaa6ac7487b457ad7d798c264c6b48ef24fe2b9789ffa1f630b6adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "406b4eaf9bb50f011363ef603542d6739687619a3bd570da052ad3022b9069d5"
  end

  def install
    system "./configure"
    system "make"

    # This should be changed to `make install` if upstream adds an install target.
    # See: https://github.com/arminbiere/kissat/issues/62
    bin.install "build/kissat"

    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/cnf/xor0.cnf", testpath
    output = shell_output("#{bin}/kissat xor0.cnf", 10)
    assert_match "SATISFIABLE", output
  end
end
