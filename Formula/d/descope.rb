class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.13.tar.gz"
  sha256 "0f2aea0e65687db859563206c421567c4a5b664b5975fc621b4c2bada17ac6e5"
  license "MIT"
  head "https://github.com/descope/descopecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97080d5c4a5b566f9c676fe756ef90e23d10a736a33db8297e2fe6ba7ac6a1b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "056ade67fc5866133bd18e5c5a3f618fc89267f07b094e88ee363d5dc36581e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "056ade67fc5866133bd18e5c5a3f618fc89267f07b094e88ee363d5dc36581e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "056ade67fc5866133bd18e5c5a3f618fc89267f07b094e88ee363d5dc36581e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a88224f03a533ea45d3a160caf9c19a3b49b1e5e1fcdd31877c9a8c6178654c5"
    sha256 cellar: :any_skip_relocation, ventura:       "a88224f03a533ea45d3a160caf9c19a3b49b1e5e1fcdd31877c9a8c6178654c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50f25ac41fc1933b3a543c758d39100c3ddaeb85bfedb3abe7d82f1f867a1c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32af76968ad226b9496568e0bf4c05252aa06a9ac12e4887d114f219d7ba5c97"
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
