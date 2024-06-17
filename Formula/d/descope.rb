class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "c4569c009503a68ae582025ea9fdc49264ceb181aa6b41f19e7f1e1366ccfd39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6628e525a5fc4e1018b3a65f22d3a533507dfab4062b4dbbbbbf5e87eba6d269"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd6f06e1bca60dfb87f1542c87654da0aee64e91505a586659c42fd3fa4aac18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44d8aabd248146db190e19ea9463357763644dfa217fc76984b90fe612092df7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a02c00a37b60679011e98f468abb4feccb6891ade6318aa88fd0f2ae0e0fdd14"
    sha256 cellar: :any_skip_relocation, ventura:        "cdd55759d40304a9b488a874bbd4a67e63b3fcb57e52922491d2665ecc476cd7"
    sha256 cellar: :any_skip_relocation, monterey:       "3ea83b0742d856c3ee44102fa379ab983e0a7291ef830c3994a459ce0e443af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277d320c320f0f05ed6c4f43ef9a0dc7330c131dd6c75bc0644ca2357c37eb9d"
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
