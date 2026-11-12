class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.17.tar.gz"
  sha256 "e278edf374cd286ad0b644834bb3f9aa8c8b21fa5a47ed40622ab9fe7fff22cf"
  license "MIT"
  head "https://github.com/descope/descopecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "184c281c96839cf6d7bd0afc60e3f9f3b03fde966e6dcd2dd94529e5d08bec56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "184c281c96839cf6d7bd0afc60e3f9f3b03fde966e6dcd2dd94529e5d08bec56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "184c281c96839cf6d7bd0afc60e3f9f3b03fde966e6dcd2dd94529e5d08bec56"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "467ffee9e5faa790e45916887804440653005e9827950fd0b61dc8cc12b5c2b3"
    sha256 cellar: :any,                 x86_64_linux:      "c3b61ec2b3b6abceb445d88515a442dcde2e34fd53fdd79567cbaea215422706"
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
