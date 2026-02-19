class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.23.3.tar.gz"
  sha256 "b07c92e7bc6adaf725f9212e0828a1a0da1ca2d9b85d6edb43d4e2f643203ba9"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b284c806c5a32b3b54fac1cf36c43929a9c184588bc168eab1ab49302eda4f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c61603c2c9110814ebba31b051f22dc3e58e200732964e140cddbe84fb771e06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7262afc94f8d2e4de4e8a84b076f63c2e575b6266aed575b516cf23876753793"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb01c350cf35dc1818ac88963a8b09d8755026bcafd9d51d6488fc9d6b03a358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e073f2acb97a9fdaf3fad3bd96c79b2802a610e3795d203f1952f538d8e4a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28c80465bc9f922858cd651cfd4a6cbcc15c41e70a144946d1d32ef4ef7e5bd9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    output = shell_output("#{bin}/cagent exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end
