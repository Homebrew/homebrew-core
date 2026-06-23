class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "6124939fbd2c8067e20fa5e6902fc4ad4aa1b7d5e7ae6b4ec47fbac24007f862"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f574f7ae980355e475ada8785b824bbb604af101af73b7021368196f0eca8c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f2bae0a8a28f8494f13dc54bd0bc149e4b06a2f431b7997a270947d3ff2800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "113c4b02a81c08042bdfb200584f8015af3d45624efbf05b86cb9c69ad8ced2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc0c34bdf78cee1f363b8ee7949eaeb147883d463e48ed5d6c71bdae252fd8b5"
    sha256 cellar: :any,                 arm64_linux:   "cc24b32d56c24d03ff359026681736ce7330333c975dae213ee140f685d96ed6"
    sha256 cellar: :any,                 x86_64_linux:  "1f6803637a3a8b33198c5843073ef9d89ef9d634b6daac0cc91aff9c6a121981"
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
