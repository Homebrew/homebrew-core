class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "7352e50fe50953ddb77ab9ee802f826df0994ce7e2c4ef212f377f0a597fb831"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6109bc4d4db2fde1ba6aadef238f2aea9a8bb259858953ccbb34344bd406d5ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5df04e7d5d90426a2861f7fc724e2f93b7823b9a8ecf641cc3bccbfd1cff7c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0a2a1c937aca1bfb01c927e7b9cc56145dad62b009948323b7736e7cf0480f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f41a93c3ddb1877a10775e9bfde35fb79d3c28cb1b21c491912a67955a0412bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "281d42b712cc66014b8bd67e94e06ee7dae2806b29a755560b39af9657145b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2b88590cd31c6841d251f1f7adcae98b4fe598b8425655fe2d62bcf1d66a717"
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
