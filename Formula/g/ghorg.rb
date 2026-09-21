class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.15.tar.gz"
  sha256 "daf3353bd0291445fef483b16b0add06bc6d08a1e08d70329b055123ef255095"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b4afbaf6a0393e82affefba24185df10eb256cce5c97d1effe36aadc3cc2871"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e69a054f67c2180fd12af6637b2036507f78138c2973d8c7fe1f225b3c53177e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e69a054f67c2180fd12af6637b2036507f78138c2973d8c7fe1f225b3c53177e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e69a054f67c2180fd12af6637b2036507f78138c2973d8c7fe1f225b3c53177e"
    sha256 cellar: :any_skip_relocation, sonoma:            "50fe556aa0c01478cf2fb1be6c9c06c3279167b9bec2238fa6127a830b31e98c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a6468ca5b3aec30eda90b8926de6da5dac2bbb0f00cbb94805f6fbe6a1baa44"
    sha256 cellar: :any,                 x86_64_linux:      "db0903ddcae771801d4be0f45fcd021a3e8ec8c503a655972114112e2c44d454"
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
