class Kissat < Formula
  desc "Bare metal SAT solver"
  homepage "https://github.com/arminbiere/kissat"
  url "https://github.com/arminbiere/kissat/archive/refs/tags/rel-4.0.3.tar.gz"
  sha256 "53ad0c86a3854cdbf16e871599de4eaaaf33a039c1fd3460e43c89ae2a8a0971"
  license "MIT"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16a805b74aa6b67aac42116f921608e77067f3f553db17931a231d6dbdb1426f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0eb8fbbc0d871dafebe61c28e50c5fb4d91197ac25454773bd49addf8d8463a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3306c59f3974c880708161055d5b84cd329180547f573a3b928331f87d954a0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5cc55b114c2d470012956c538e7004381ebb4991a8f493fdf65419eb5b16c9f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "653211109e2c4ad824fb4d39bb1f1f907c0d6f3e1f0455448e56d8f7546ec03b"
    sha256 cellar: :any_skip_relocation, ventura:       "fc191b61a8fe46d85a4796b18a6563763c46aa6b1e2549d656e5fcff30762d5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a2c2652d7dedd33d9bb02ad38a44333d5e89268c61c11477772659569f764b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05888f8299dea43a8b164e6317277033fc2543a6f4aaa9a0b1d67b51e0dadc7b"
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
