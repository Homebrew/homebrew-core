class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "10dcc5c9dee4a61f53157390326727d5f63580ab096369b146dd54bbaa8abeb5"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc924569d1cfd81b13fffcd82017bbf4898773e42c715a56e5d17f5102cf8ce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "260a4b78a717e4418a0c045374165c5e919d6e3042be772344989da7ea63d19c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72bf2d675ab4429a5a7f9cf6550e72dbbde467a49aea90fd88901e80a8fcbd31"
    sha256 cellar: :any_skip_relocation, sonoma:        "d72d390c5e74038c544d8a56028b1db5457fbe54c41667c81f3ef0ae9535c8c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dadc58a255abd96a0898cc89c75c3bfc50f5ca19dd69c515be2d28f2715422a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d852a910ab2f91d75a160f9f915608d23e8516bba5ef2d28e79eaa1723e2b93b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = spawn bin/"openfga", "run", "--playground-enabled", "--playground-port", port.to_s
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
