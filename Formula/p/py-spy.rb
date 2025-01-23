class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "13a5c4b949947425670eedac05b6dd27edbc736b75f1587899efca1a7ef79ac3"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbcd2bcf46a3f65af4dbde6a6a92eb8d59a301922b23b680225d16daffb8c0be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3bb71312de168ff73871311d675eaeeb3b1b6e18f16b9e293fdd2e0cf8c9790"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "435af0f030c2ea05c0b55327f5947b3605159116f2f78e770c690a16a39da565"
    sha256 cellar: :any_skip_relocation, sonoma:        "54396a0c050b5504064dca4b99be3a6fdaaaeca5c774877b4df8f442374bc62c"
    sha256 cellar: :any_skip_relocation, ventura:       "b9c65a548a147573ebe2659f64b0474e449ca41e6f803b9ad876bf0712316869"
  end

  depends_on "rust" => :build
  uses_from_macos "python" => :test

  on_linux do
    depends_on "libunwind"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"py-spy", "completions")
  end

  test do
    python = "python3"
    output = shell_output("#{bin}/py-spy record #{python} 2>&1", 1)
    assert_match "Try running again with elevated permissions by going", output
  end
end
