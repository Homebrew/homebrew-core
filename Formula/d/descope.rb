class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.18.tar.gz"
  sha256 "41c3af732258df9b8e5f786c4c73dfc0a9c5b16911904ae6d5800454da7eb36b"
  license "MIT"
  head "https://github.com/descope/descopecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f059873b27df725abb37fc212c5d50006994c381dccd3c7a8fa81cd05ec4c34"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5f059873b27df725abb37fc212c5d50006994c381dccd3c7a8fa81cd05ec4c34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f059873b27df725abb37fc212c5d50006994c381dccd3c7a8fa81cd05ec4c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3277f563a4b73bcd07bd7495e6e2986803887975e87304775b408e94ea01805c"
    sha256 cellar: :any,                 x86_64_linux:      "b46c4c7d95ee98dc83728074deee33c613a817ce9733dbc9df0f328373c18e16"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"descope", shell_parameter_format: :cobra)
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}/descope audit")
    assert_match "managing projects", shell_output("#{bin}/descope project")
    assert_match version.to_s, shell_output("#{bin}/descope --version")
  end
end
