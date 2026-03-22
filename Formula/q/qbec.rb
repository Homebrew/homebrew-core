class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://github.com/splunk/qbec/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "26dc4f5e4749e82c6f446a31b9eb47ac512178a39e45de237c937dd0b1b96d90"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9462e25ab6e0625df3e736d18b8c8185fe5ab3868c72007910bf93c2e06e1604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8294a6942ed9967596d21d5a0b1d3716b73eb20b8b79268e8c54a5b7b95f42c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "922df35073317307b502e490cc9ba9d0ab8028a4b560c9adf95d8ae71f3aa078"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c1f4f0add2624db4c34e31294df8b15e7bc5d588c3f0e4b1141795307641861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1790ffe807e928176b6cd98746a40d7f4057b867ba15436e21bda292328c62cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96b2926505ccde48caaee06e933566ff6c35523af5875c38730baeb0fc771ced"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=#{version}
      -X github.com/splunk/qbec/internal/commands.commit=#{tap.user}
      -X github.com/splunk/qbec/internal/commands.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # only support bash at the moment
    generate_completions_from_executable(bin/"qbec", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qbec version")

    system bin/"qbec", "init", "test"
    assert_path_exists testpath/"test/environments/base.libsonnet"
    assert_match "apiVersion: qbec.io/v1alpha1", (testpath/"test/qbec.yaml").read
  end
end
