class Gcx < Formula
  desc "CLI for managing Grafana Cloud resources"
  homepage "https://github.com/grafana/gcx"
  url "https://github.com/grafana/gcx/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "689822b98e5bafb0392133397240892bfa0f4ce1cbe602a7ae471bf4c928d60e"
  license "Apache-2.0"
  head "https://github.com/grafana/gcx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de6db3dd18b03c884e2bcfdb0f22193ac7b36da0010b701da307bf113c0b5921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d126418e5059f014874729b8428e5d064c86124ec12a50aa039697932139302d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a2f1f1f1c09b84e1b16c21a8e8ca5056793c674f87f53c9b37e6e278423489"
    sha256 cellar: :any_skip_relocation, sonoma:        "378fdb56843e7aab59daf6a708e104af2671a5459d3a7360e53807fe817644be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e43058dd629d90bad2a092eb52a002dcb7cac6985d861786260a32c22f2dbf40"
    sha256 cellar: :any,                 x86_64_linux:  "c51c36925c623ea4ff3ef4f85a59e86b3dbd1b10b9ffde0a35120bb03f0be7a8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.commit=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/gcx"

    generate_completions_from_executable(bin/"gcx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gcx --version")

    system bin/"gcx", "config", "set", "grafana.server", "https://grafana.example.net"
    assert_match "https://grafana.example.net", shell_output("#{bin}/gcx config view")

    assert_match "Unknown output format", shell_output("#{bin}/gcx commands --output bogus 2>&1", 1)
  end
end
