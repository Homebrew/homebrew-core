class Lnk < Formula
  desc "Git-native dotfiles management that doesn't suck"
  homepage "https://github.com/yarlson/lnk"
  url "https://github.com/yarlson/lnk/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5c4fd9ced7c86813683fbebd608bf7438ef5e805b00b27f748f764d9d0624270"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "055a54409a0a2a53aa4b0d3f2579eb99f73b0594d071ab9d5491c32237bd9af0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "055a54409a0a2a53aa4b0d3f2579eb99f73b0594d071ab9d5491c32237bd9af0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "055a54409a0a2a53aa4b0d3f2579eb99f73b0594d071ab9d5491c32237bd9af0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d326f2fb6241ca83a3b15574abfb8947968a5ef017e220ddc4c51d210c9c423d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78c8e6195d4b0d0e97deb873aafcb92b85867a0bceba10f91c87960acdc3fc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20920e2cd0a28753716343bb44158f1113d446346bdf54ac2387af64d6b77dc7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lnk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lnk --version")
    assert_match "Lnk repository not initialized", shell_output("#{bin}/lnk list 2>&1", 1)
  end
end
