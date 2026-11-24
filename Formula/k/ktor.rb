class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https://github.com/ktorio/ktor-cli"
  url "https://github.com/ktorio/ktor-cli/archive/refs/tags/0.5.3.tar.gz"
  sha256 "ce633bc15f8d15f79d438cf6aee1bf005714ae54551cf35dd4f6f2d4381f3fe1"
  license "Apache-2.0"
  head "https://github.com/ktorio/ktor-cli.git", branch: "main"

  bottle do
    manifest_sha256 "53d8b7dbfc6e5638fdb2e8bf464666054c52a4e22a1ae5607e073c2b1002465f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e01e19290b9091792d8b86095d2541fc41ccc71680fe324dd4e0ff8f7f161d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf36667b503c7b500a4f4e23dfd44729aaf2184eca250f676ae99c4128173346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "556a4b23d03fbbd2e54734decd1f7e92905fd2a13af8073a88dbcb727bc1c4c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c7c9b3dc318214a450edd351c3380489a208f28b8208f7d79934d820cbe99e6"
    sha256 cellar: :any,                 x86_64_linux:      "527874c98005ccfae979f1ce783a0fa26c6bba78eec10450d0cb54bf61d3773c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ktor"
    generate_completions_from_executable(bin/"ktor", "completions")
  end

  test do
    assert_match "Ktor CLI version #{version}", shell_output("#{bin}/ktor --version")
    assert_match "Ktor CLI version #{version}", shell_output("#{bin}/ktor version")
    system bin/"ktor", "new", "project"
    assert_path_exists testpath/"project/build.gradle.kts"
    assert_path_exists testpath/"project/settings.gradle.kts"
    assert_path_exists testpath/"project/gradle.properties"
    assert_path_exists testpath/"project/src"
    assert_path_exists testpath/"project/gradle"
  end
end
