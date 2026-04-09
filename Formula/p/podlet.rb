class Podlet < Formula
  desc "Generate podman quadlet files from a podman command or compose file"
  homepage "https://github.com/containers/podlet"
  url "https://github.com/containers/podlet/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "9dd2ce4a618563f8cb607106eb8082744b228575627bcc5e144c9f076e4be691"
  license "MPL-2.0"
  head "https://github.com/containers/podlet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc471108617fc203ecceac688a9eb703c744680c2e5a9d9f873e477515a04f92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3f1b5d2182d796082ad6811bc3d9b391a8b461a07fd11d3508eb42f7f29502b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45bec0840eded4df3d1d9390fdeb91db26bfbaeb0c850a1583faa890b9473b8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1168964af1504a1cc1166d2e66bdbae4faa93e0f5ce016b9c4db0934cc45d182"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c00b41f7eed19cd547b29e50af9aaadbb27ae14518612eb5eff92d7fd88db30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "182fd52f71ae3ff1d511d083d76c18dd267cd22b44bcaa974088afb452902c11"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = <<~EOS
      # hello.container
      [Container]
      Image=quay.io/podman/hello
    EOS

    assert_equal expected_output, shell_output("#{bin}/podlet podman run quay.io/podman/hello")
  end
end
