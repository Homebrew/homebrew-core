class Agentbox < Formula
  desc "Isolated dev environments for parallel AI coding agents"
  homepage "https://github.com/Ayush2966/Agent-Box"
  url "https://github.com/Ayush2966/Agent-Box/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "3aa8ef1713d96d63a9e8aa2fbea2711cc085a4649e742af066e69437a5f4d899"
  license "MIT"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    # The web dashboard is built first so that go:embed ships it in the binary.
    cd "web" do
      system "npm", "ci", "--ignore-scripts"
      system "npm", "run", "build"
    end
    ldflags = "-s -w -X github.com/Ayush2966/Agent-Box/internal/cli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/agentbox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentbox version")

    system "git", "init", "-q"
    (testpath/"package.json").write '{"name":"t","scripts":{"dev":"node server.js"}}'
    system bin/"agentbox", "init"
    assert_match "version: 1", (testpath/"agentbox.yaml").read
  end
end
