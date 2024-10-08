class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.10.tar.gz"
  sha256 "80d1b35ee7163fc038e7a02b925978107715c863c73b9ea8a127a8d776ca6cce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eac2e0ce92cd7e88d109303ff5c32574f28793b833e155db0635b8b95016c50e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eac2e0ce92cd7e88d109303ff5c32574f28793b833e155db0635b8b95016c50e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eac2e0ce92cd7e88d109303ff5c32574f28793b833e155db0635b8b95016c50e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c747a95475f846efab3275f76322edc327b0a78833d220d3bf6f62a33e46cace"
    sha256 cellar: :any_skip_relocation, ventura:       "c747a95475f846efab3275f76322edc327b0a78833d220d3bf6f62a33e46cace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc85b68ab36c414d058a231779d95319cc0d8ed4891bac475e9b2a8f81fbede"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"descope", "completion")
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}/descope audit")
    assert_match "managing projects", shell_output("#{bin}/descope project")
    assert_match version.to_s, shell_output("#{bin}/descope --version")
  end
end
