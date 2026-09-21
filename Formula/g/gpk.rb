class Gpk < Formula
  desc "TUI and CLI that unifies every package manager on the system"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "42c6a369bd97a0e084ecb878dc52122f4610071c846cd3bd8209518f2c468a7e"
  license "GPL-3.0-or-later"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8105fbfa2bdbf20dee03365bf1179397a0286fd78336b49ccc098ee9501b7240"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d9d4ff24f127d913c5238e379e36f8f89e6531d9f6d340f51cd14f49fa15af5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d9d4ff24f127d913c5238e379e36f8f89e6531d9f6d340f51cd14f49fa15af5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0d9d4ff24f127d913c5238e379e36f8f89e6531d9f6d340f51cd14f49fa15af5"
    sha256 cellar: :any_skip_relocation, sonoma:            "9d2977707f4969b35ba3c24923eb4da3a3357fef1babaa2ac3a601879557861a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a5114717d365aa1f4e449479bc68bb5ae5bd1d0763d0c13a8e36567f8af45c6"
    sha256 cellar: :any,                 x86_64_linux:      "1a4d6025f36b7cf8e2f36eac7f1d35d4cf4291720fe31d3a142edb3b3999d789"
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
    require "json"
    listed = JSON.parse(shell_output("#{bin}/gpk list --json --manager brew --quiet"))
    assert_equal 1, listed["schema"]
    assert listed["data"].any? { |pkg| pkg["name"] == "gpk" }, "gpk did not find itself via brew"

    # gpk must recognise the Homebrew keg that owns its binary rather than self-updating.
    assert_match "brew upgrade gpk", shell_output("#{bin}/gpk update 2>&1", 1)
  end
end
