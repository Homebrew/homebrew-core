class Abpoa < Formula
  desc "SIMD-based C library for fast partial order alignment using adaptive band"
  homepage "https://github.com/yangao07/abPOA"
  url "https://github.com/yangao07/abPOA/releases/download/v1.5.5/abPOA-v1.5.5.tar.gz"
  sha256 "2e2919dcadbc6713a6e248514e2d9e9cb93c53c5b36dd953a2909ad2e3fa6349"
  license "MIT"
  head "https://github.com/yangao07/abPOA.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62321fb97adfd0bb3614e437bb49adfa3a87923aa96a17cb2738675fc9d01da6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d99d2f859cd56d1d06787039c099a3f247f191ac4c35fba6a241a7d396d26ade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1266cbf22f7d1f8cf4ee44ff06fb11f6ea533b3d82dbc86ade7da9d5ea43a7fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebec63c632c528cf0f20b8dab8f10242b0f9f3c10af2c88da5d9c13bba7ba54b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "743f18fd8c925dda50dcdad77fc0364d524971081fd4f9e74c69ddd1cd59072d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d5004a9b863f7a56b71192b1312a9e462f5c573e0c3753655dd2117bd19a6d"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make"
    bin.install "bin/abpoa"
    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abpoa --version")
    cp_r pkgshare/"test_data/.", testpath
    assert_match ">Consensus_sequence", shell_output("#{bin}/abpoa seq.fa")
  end
end
