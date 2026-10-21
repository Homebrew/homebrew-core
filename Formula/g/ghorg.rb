class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.16.tar.gz"
  sha256 "a8f172c428ee341b49025dc4b08057b3910714e78ab7941f8e93bd091710ecca"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d23ebbb6fe52c861cad13bb27aaf9efb6a2cf8a8985e19467676ea7aefac0dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d23ebbb6fe52c861cad13bb27aaf9efb6a2cf8a8985e19467676ea7aefac0dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d23ebbb6fe52c861cad13bb27aaf9efb6a2cf8a8985e19467676ea7aefac0dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ab6c780d090958fd87d7d84ef9f54118139ab0df324c5aa7e107f5bcaed7f5b"
    sha256 cellar: :any,                 x86_64_linux:      "8bb075d5523b959cb3ea361e87c260f193c04dec77708b13a26e19e3e993bfad"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"ghorg", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
