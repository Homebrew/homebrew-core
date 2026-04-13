class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "de68411f56be8423a6a20536cb0e50b41ee029e8c8b4ce2d90333835cb18f828"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5afce4b60ed24957521df2b9a61241cd5b6d37fa9802a4f2e53b51811a7c461"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2abe3a402dd2b3ef433484592b57abd5ddaeabe8feeddc4be4be540a7a0ad18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ed4104d52cbc831826a469e63022bfa26245e0a5b8a987d71472448d555a22e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b9862c53b9af76efb8974616873561f92e412569e96e32db3e82452b1a3aef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c23be7bf5242fdf5d75820d011316222d1822a03ff3e61f29a8edf4aefee25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a74ddda2bd76df27eeed04730fc45c9d8ce36ce4041f7d25e4b23372ef4b87a8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
