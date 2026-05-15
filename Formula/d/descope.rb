class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.15.tar.gz"
  sha256 "78a6ade619839d8fd822b2efec5431a1d9f9d45a1bd1b60aab0048a95e32c8b9"
  license "MIT"
  head "https://github.com/descope/descopecli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74cd8ef58b15b1f107e1b146b512f3cca0d801616654e8cff59da1ca549a2bbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74cd8ef58b15b1f107e1b146b512f3cca0d801616654e8cff59da1ca549a2bbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74cd8ef58b15b1f107e1b146b512f3cca0d801616654e8cff59da1ca549a2bbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b639d18cff586a44788ff0ee4dc1303c5b87d354ea56d8b152db298f6da4ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed568a0c7e895b958f619f2d7f478f565f715d660f0671a5380003e1ea5a05d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b4eaf4c98e34b2741a8a0260aeb28a8b751defdd840b6b3792b4f709ea38d9"
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
