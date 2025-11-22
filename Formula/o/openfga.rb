class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "d538aca96b22ec52ef708b4181488f057223cfd43d2ce028bf9c56f550f5e397"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b435fd68cddd3a50ee7957432d70c1a9069cddb3ce8bd3c4b2afd6685c72f043"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2080fb2fd03cebef19e0e649954dc2d844dad1791a4141d8d8b79818f3e10e6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9704343b9dc3dfa0d540dd417851f24da472d788583a60e3cf6eecab713e7ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "729dee93d39316f20f66d75501935f8d9285b510523ce61782b90c2d93df1953"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fd444a963052725b12f24765d43c1fd3d6cc9f311bc21ef6f1b8234cf3f2d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce495587ccc8e65e22b1cd1ce4058d6d74b43f72880d2a3260c5de743473eb69"
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

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
