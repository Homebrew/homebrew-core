class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "81bca172328b78191ba6d3ef7fa90fb8c88e2260f2499a11e06ddba8517b91f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ff7a8c10b423ff76fa2516c9f528c8c47e0e08b5d2f0580a18ec12787c2ccb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26fc67714c66e786ceafba2575fd5cbcdb19224528d0174bcfdaa4f947d7f9c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "006dd500e20796a79ca14484a9e399cbb99acec8ab0bee52d23336a3c0a1be89"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a9ffc997ec0e3bffbbb960e4956ee49fb993cd346f87eee89cf626a81db752b"
    sha256 cellar: :any_skip_relocation, ventura:        "e084971942408a9b8e079b467c37e2909064602c4cf6887c3513099073b6998a"
    sha256 cellar: :any_skip_relocation, monterey:       "fa894256db04ded06d9203bdf2d3f948ba876d3df75d467f94286b1d602024c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80a0308adf85eb88cda19d9d1bb9aa6862b05ac6baab3b2810abdb0bf59767de"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
