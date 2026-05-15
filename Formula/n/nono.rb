class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "f28722d52f50855f78ed0025a7e7a8be78fe475f6c6910a6327ad7e89eec59a5"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "effdd7f63b83305f3f6f064b6bfdba13021ffbd0c389ae2a066b3decc093aa28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "986a38e0065922af29c35433feafa79094bb94b6b4d029032c039ca5eeed89c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38037df182836ae0c9b13a064429cacbd13c1ca2328e94d7d26e184dd61d8cfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "54c9d8c990ca6d0660809e1fadea5f48f48e27c5f5ee2ff1ffcb0050de6dfa61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84829d1b057948e8a7c36aa040e633e70f27056b7dff4a73898da17fc425a853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ab7f336724a7fb3437c2c28f5977b32ab0e2683ab4808ec529f0d9c8f7c950"
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
