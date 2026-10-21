class Gpk < Formula
  desc "TUI and CLI that unifies every package manager on the system"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "0c7f708564e2e35613161ebba7ae9c980493cce667c0a5f8946ace75eb08c100"
  license "GPL-3.0-or-later"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4578d42d4012d021fd5c0457ce05fb351c6c8610b993f6f8d784974b81e504f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4578d42d4012d021fd5c0457ce05fb351c6c8610b993f6f8d784974b81e504f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b4578d42d4012d021fd5c0457ce05fb351c6c8610b993f6f8d784974b81e504f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "05e849b49a51962e1cacec3ccd56a4355b821c91ccafbaba25ff2b584f0d7deb"
    sha256 cellar: :any,                 x86_64_linux:      "0d6868c5713fb22c4725a32d962c08d09724a2bdacebdefd553e26ab120a25d9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}", tags: "noselfupdate"), "./cmd/gpk"
    generate_completions_from_executable(bin/"gpk", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpk --version")

    # gpk must enumerate the real Homebrew installation it was just installed into.
    listed = JSON.parse(shell_output("#{bin}/gpk list --json --manager brew --quiet"))
    assert_equal 1, listed["schema"]
    assert listed["data"].any? { |pkg| pkg["name"] == "gpk" }, "gpk did not find itself via brew"

    # gpk must recognise the Homebrew keg that owns its binary rather than self-updating.
    assert_match "brew upgrade gpk", shell_output("#{bin}/gpk update 2>&1", 1)
  end
end
