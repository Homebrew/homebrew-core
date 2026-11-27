class Gpk < Formula
  desc "TUI and CLI that unifies every package manager on the system"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2571f6005046d77dee9d5f0f4d2e5981887988d43c3cf6c8d1da5e8aa7d91c48"
  license "GPL-3.0-or-later"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    manifest_sha256 "32d1e5d7a896c2518925f325af9f783bd24c23bfe6a1e586d1f1038c6c935df9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41a72a1e8c838bac6af7d62d97cfcefbcd6ae919ab0a95c20a39cc3fc2151b3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41a72a1e8c838bac6af7d62d97cfcefbcd6ae919ab0a95c20a39cc3fc2151b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41a72a1e8c838bac6af7d62d97cfcefbcd6ae919ab0a95c20a39cc3fc2151b3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f04575cb1e711b08bb33dd4b763f4961213d4c1b9852fc68cb56fbfc076975b"
    sha256 cellar: :any,                 x86_64_linux:      "6e144cc51c20f0e0091316cb5c9bc7019041d7c74ff23603fe4e49c3a23c5ce8"
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
