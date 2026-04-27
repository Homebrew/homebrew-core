class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "bf01fce3524cbf6ec9486cc7d1e9316232249a10880194bcd0df7a4e5cc3ab39"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90ff1933102492a190353169807edbf9ae899a529730bd4976af3a835e2a3e3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2372e9c5636537ee06a5091b73c5d3e91a021dfc4c057f3f34321bccdf538d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "041fcb0fc55e5206311fb2e0dbf9de1b206a1d2d10dc49bd46562f314b2a0cc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7077cb7ef93e90f3962ea5db776c4cc2e0049fe045e7f26fc3f1c048649f1637"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d59d200cf90dd21a3c205164619b8d708c1bc774191fa4e5663db12f4c527779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc329689a3d89c80e5ab0da9c13c1b958d05bdeded08bf9129f848402c79e6f5"
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
