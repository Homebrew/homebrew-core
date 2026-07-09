class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.app/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "d177e4aeff702f699f2b5c8ea37e75c3736582fa2c9956e2751e69ad6287e16f"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d269d263ebb3fbacc71b99f7ec9abc01b315e28687cb57472ce3fae76ad42c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5de3d78efcf62bedd807c401a2f57f92e80f297fd129964ccee1819f4f6e0e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58cc4575d95baf0af9edf932acbd2b696a3ff4a3e9945f75419c8d1050badf70"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f0d7128e03d4538d51987f7e497db2f42a9703f6700cd32757b983067502df7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd4816483772bb88a7ecae14e7fdd64a310d0b37960146b3cb6eceb62a7a1e5f"
    sha256 cellar: :any,                 x86_64_linux:  "01f1a5f503e41210a416833d40119b942e9877957d1864386a3c9dba5a2fef88"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
