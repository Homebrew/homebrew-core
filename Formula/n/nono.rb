class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/nolabs-ai/nono/archive/refs/tags/v0.65.1.tar.gz"
  sha256 "a342deed7c16742c955b3a2bdef7ba558476bedcd298ee12c95b5dd47a381a9f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "691614867da113b2730516bb9fa70ec9358da748cc2f22923b6fdf089a5c776c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb6d5ded4f2c32e06face9126bf191964dd0bde3f286ec417b827fe1c6ae240f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25473188a03f14c8ef24efe2df5cf79775e143ae385b2c7f169be4d7298262a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4e94bb8ade0f947bf3d18ac97ee2a889ae70d1c22975fb2922068102125060c"
    sha256 cellar: :any,                 arm64_linux:   "5e74a4d0debe3c61876dd7d855f7bacad326043771162c8ddcdae1d2e0d1cf47"
    sha256 cellar: :any,                 x86_64_linux:  "895df7d5ee203b5862e65ce9c0fd1c5dcc6b0d413f002cc3be93d5ab6a65e2c9"
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
