class Cek < Formula
  desc "Explore the (overlay) filesystem and layers of OCI container images"
  homepage "https://github.com/bschaatsbergen/cek"
  url "https://github.com/bschaatsbergen/cek/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5a8f7633682dfe87ed77b5b88698de11a5b1a10b019e274e98b1ce4e803b466f"
  license "MIT"
  head "https://github.com/bschaatsbergen/cek.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac9a9cebd2b774064d8d6f840f916d823455bb8f669b3516c6e1d2bbbf334772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac9a9cebd2b774064d8d6f840f916d823455bb8f669b3516c6e1d2bbbf334772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac9a9cebd2b774064d8d6f840f916d823455bb8f669b3516c6e1d2bbbf334772"
    sha256 cellar: :any_skip_relocation, sonoma:        "88406c81115ce084e9b458c02f89be3faaee82cc7e681eb4f1911bf38de5261b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f2a79add55a2d02aa33c5ca31aedb992113efd49106307cd6e41b694ed741b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b0ed52afade67d78f5ab78d98b495622bc02f2ce45d8a442f9eb2b0200f4ef3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bschaatsbergen/cek/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_includes shell_output("#{bin}/cek version"), "cek version #{version}"
    assert_match "localhost", shell_output("#{bin}/cek cat alpine:latest /etc/hostname")
  end
end
