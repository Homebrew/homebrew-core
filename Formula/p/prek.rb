class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "845e45cd3ec228029410aacab006f7f9d3676698c9ab5047bec105f5a891c65e"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4396429dd89a65ec9e290da5af7af52bb4ec690e29412011e489654cbb991569"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d13ed98330d7f426614abda5b9129a645b42be58130c6e2bcf960a74516162c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63af904242e0ce1699c00e090b796800ef322a8a2b52dd10c71d2b723e5de1c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b27f346aa1ca16041fc1914b2f2cf6f710f506b599c104f38c2001eb7d555706"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6be0f4cfa11ffe3214429e3686f401bd80cfb20fd46df18bf6ad515de60c152a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285f5b78c7e2591e5980fe607730830b261f8ea4b2ae0f7c2a15aa0ce8064914"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
