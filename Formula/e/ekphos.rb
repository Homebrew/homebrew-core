class Ekphos < Formula
  desc "Terminal-based markdown research tool inspired by Obsidian"
  homepage "https://ekphos.netlify.app/docs"
  url "https://github.com/hanebox/ekphos/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "fe42ee4e01b31041d2813c91d88271f3cebbd0d16cc79eebce9a1289dbecbcea"
  license "MIT"
  head "https://github.com/hanebox/ekphos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e610c3b7d4b929c3f4662abe2d4426ab2f58ba0c8a06b10c4e2c0f06b47dacc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7758a2075634457eff0d3e2e74bfa0e308458ce560686fd954082d358926a6b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "022cfa0ab957b641207d5cd07cb1b2d5f15e28c79fdd12a16e37fda2a50c7c6f"
    sha256 cellar: :any,                 arm64_linux:       "1c7f74648da65f7d627c276973835131b7f6c83b258ea7769b355d16aa400cf5"
    sha256 cellar: :any,                 x86_64_linux:      "d9fba8e94fa23cefbca2455042e132fddb8b29d26395fd48d204ebf954d529e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ekphos is a TUI application
    assert_match version.to_s, shell_output("#{bin}/ekphos --version")

    assert_match "Resetting ekphos configuration...", shell_output("#{bin}/ekphos --reset")
  end
end
