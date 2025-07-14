class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.48/nmstate-2.2.48.tar.gz"
  sha256 "67325c38c69338836d298541e99b5c9fbe78bb9b30e47e8f65ae7cff0c7eb51a"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41d4209a581ba4843b2e10db5d21b5b439188fa58f46c7b410799b7e73ec29fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b377f0d7e885a8e303df719caf1789fe50ccb22d230c940211f7900dfba5de36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "778cd75ad07901b73fa78e364e39907930bd893fdae927a13932a1352ce5bc6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5fc77b30cccf00fe6183db6929835ce6c8b92ab2d9f6e5cb37156094e1a4975"
    sha256 cellar: :any_skip_relocation, ventura:       "a32e8d8bd76d25928f376cb8860e7c6bcbf937371e1bf62d8461cd8a172e05ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c78294b917da1d1d104dadf16bc55a273733890f620c66e48851c85aece98f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfdc3ad14d486900c01891f0f2cd309b9eae7c148fe0a80fa71cdc2de2aec60b"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
