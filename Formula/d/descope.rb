class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.13.tar.gz"
  sha256 "0f2aea0e65687db859563206c421567c4a5b664b5975fc621b4c2bada17ac6e5"
  license "MIT"
  head "https://github.com/descope/descopecli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6aad2b0f78e9b6c0b7f6289535925ffb673418ea50e0c9fb636242408cc54984"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aad2b0f78e9b6c0b7f6289535925ffb673418ea50e0c9fb636242408cc54984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aad2b0f78e9b6c0b7f6289535925ffb673418ea50e0c9fb636242408cc54984"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca173393ec20b0b276608e1ff9cb3ba8b3d21f849dfab57407ab452126d50ca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c7ab386ce6d9073abc2e20e11aa729a1bcb7a0f083ac5bb11821d5f40a9683c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbcc83e5fe21decbc2bdf875a3fab9b20743219499d1c979eabcef15cf30c1bf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"descope", shell_parameter_format: :cobra)
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}/descope audit")
    assert_match "managing projects", shell_output("#{bin}/descope project")
    assert_match version.to_s, shell_output("#{bin}/descope --version")
  end
end
