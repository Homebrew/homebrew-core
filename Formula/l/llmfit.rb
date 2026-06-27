class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.33.crate"
  sha256 "663e079f3afd48008cf919266b7bcabdb23afed43195a0ccfa45b5ef44cfee67"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5db413ac4bdc67be41a9d78e07e3d170891f6e4cdfe833d72df901f72af976d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67a817799fb938a2e4488f540260c9880c56a65356b564f40d03ae113e852a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "528b66b8df729876d8aaf0b1c1300be359b136f20c44031e06db2bd06ec0eeb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5915ae14d1fd2fdc218fb3d62eb9f495ef949e28a19bf4f290f2420fca93417e"
    sha256 cellar: :any,                 arm64_linux:   "fa1414502786b0fa71c6b5c0705426eb1f016721e324e121922391c0b6b92b07"
    sha256 cellar: :any,                 x86_64_linux:  "881253b8bf09fccc19533cf658c85c0c11ede833b4ae952d500463b13cf3911c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
