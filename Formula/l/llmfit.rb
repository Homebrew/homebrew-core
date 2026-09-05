class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.14.crate"
  sha256 "2ac16516c3210f7c669b2a1b057db65371215da98b0dbfaea22c1841cfa7db29"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35babbe3d3fbee66d77e86c7fd299c86d6481500169ecba4bceebe09fc1d42ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67d0d9e8f8a9895cdeb7f33a751f3b686df6cb6f826538f465efd9a7206643fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4176d80df5d4ed4e228f5b98ea18ed0289baf22f54876ef29945c36512d643b6"
    sha256 cellar: :any,                 arm64_linux:   "48ea86cc3a09e9c3742fdeed6fb79ad8f23dad24a3a58c120db27c624ce35105"
    sha256 cellar: :any,                 x86_64_linux:  "daf3ea926c68892918f63c9d8814af7edb0a219e07f64ce82cdaee8f11514a0c"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match(/Found \d+ model\(s\)/i, shell_output("#{bin}/llmfit search llama"))
  end
end
