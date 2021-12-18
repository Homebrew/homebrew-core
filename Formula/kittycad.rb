class Kittycad < Formula
  desc "Command-line tool for interacting with KittyCAD"
  homepage "https://github.com/kittycad/cli"
  url "https://github.com/KittyCAD/cli/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "54b0520d6cb033c5c6ff53fd66062b4eda6c01bacd3af5d9493d0d98f24dee6f"
  license "MIT"
  head "https://github.com/kittycad/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    system "make", "build", "gen-man"

    bin.install "cli" => "kittycad"
    man1.install Dir["generated_docs/man/kittycad*.1"]
    (bash_completion/"kittycad").write Utils.safe_popen_read(bin/"kittycad", "completion", "-s", "bash")
    (fish_completion/"kittycad.fish").write Utils.safe_popen_read(bin/"kittycad", "completion", "-s", "fish")
    (zsh_completion/"_kittycad").write Utils.safe_popen_read(bin/"kittycad", "completion", "-s", "zsh")
  end

  test do
    assert_match "kittycad version #{version}", shell_output("#{bin}/kittycad --version")
    assert_match "Perform operations like conversions on CAD files", shell_output("#{bin}/kittycad file 2>&1")
    assert_match "Get information about sessions, servers", shell_output("#{bin}/kittycad meta 2>&1")
  end
end
