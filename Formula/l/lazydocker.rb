class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "480234dec2dbe989462d177f1aa78debec972893ab5981d48d23d7aec8430a58"
  license "MIT"
  head "https://github.com/jesseduffield/lazydocker.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71df0bb94437981ddd5be7bdf2d8ea8d5a4ad881c0ea782cfa86513d5fef1e2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71df0bb94437981ddd5be7bdf2d8ea8d5a4ad881c0ea782cfa86513d5fef1e2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71df0bb94437981ddd5be7bdf2d8ea8d5a4ad881c0ea782cfa86513d5fef1e2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6263e0c635c434ce1484f9660ffd3ba553fd2c3220ad6d98c5e637a01a3fd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1be1bc7597a9c3358a4ef4af4e159c59a4b8afe411356a9a62715e77eaf3416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a400ed7cbe746a63a141cb4afa1d885ad3d9ae4afcba283d6a79c965f0e23c56"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
