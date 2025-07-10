class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.47/nmstate-2.2.47.tar.gz"
  sha256 "48f67d678c8adb3dc003c8b32076d5665bf615f561b13bd967c58e61a4e67775"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fe5f5bb22681db481b61293a8c99441136e5d0d2daebf9c798d675df3f47631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adf2babb7fdf9f70ec8163b83a6a70678cb2de05c324b53d28100d7a1efdf94b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cc1c95b7d08bf0addf1790cdc03e7aaa43c057d9ff9f0ded5e35bad76b3891f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4ee4534769d31241349f03cd78c6389ae34043bc7be69845d04f91c6cd0e289"
    sha256 cellar: :any_skip_relocation, ventura:       "e8fcbe42755326433e47b2f1252fc25653a1053da245f02445d1581703391765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f646d94b1cb8169cd333d62fc4c968e21c410f227103c2b1bbbdc2260f46764b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c481fa1c9d71ba4749bfb5af98be8efae63d9c3fe0117b7c7dd31751fa6cc8e2"
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
