class Kool < Formula
  desc "Web apps development with containers made easy"
  homepage "https://kool.dev"
  url "https://github.com/kool-dev/kool/archive/refs/tags/3.4.0.tar.gz"
  sha256 "706051161e8b97a79e9144e58a59a1bfae0553febc13de65726f0e3e67727be6"
  license "MIT"
  head "https://github.com/kool-dev/kool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eeec48a93221e8c641a1eda7f6954fa3a22764152678dc2d707fbc7433a1a04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eeec48a93221e8c641a1eda7f6954fa3a22764152678dc2d707fbc7433a1a04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eeec48a93221e8c641a1eda7f6954fa3a22764152678dc2d707fbc7433a1a04"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e16937382c6f8f7c99575b832a5990c6881ae73bc46348f45e2a1bf41ff86bb"
    sha256 cellar: :any_skip_relocation, ventura:       "5e16937382c6f8f7c99575b832a5990c6881ae73bc46348f45e2a1bf41ff86bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "082b32596a7d62e8e53034608a8d96e8056d5cacb5343f65a24ed655ff436c20"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X kool-dev/kool/commands.version=#{version}")

    generate_completions_from_executable(bin/"kool", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kool --version")
    assert_match "docker doesn't seem to be installed", shell_output("#{bin}/kool status 2>&1", 1)
  end
end
