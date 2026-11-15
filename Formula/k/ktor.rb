class Ktor < Formula
  desc "Generates Ktor projects through the command-line interface"
  homepage "https://github.com/ktorio/ktor-cli"
  url "https://github.com/ktorio/ktor-cli/archive/refs/tags/0.5.1.tar.gz"
  sha256 "dae763ded73a786dd183258e71af6001bea9b63fa357f50be78d0c3c2dcc8953"
  license "Apache-2.0"
  head "https://github.com/ktorio/ktor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0088c7a990eda7ccb705bc161fe753c1da32c18a1ddf629adaebd8fdd005b6b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "855e7b79185c9d6e2bde31070b4b3b036a4df86ea5494c795be653e58b9d8736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "228305902ce369c7415b24fc01ceec9eb6e07fb954b2df96ca5f23c65f72c773"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e06f73b85ed6aeafb44ff23b2616b0e4e865e7af49f5fded59994b7132672e52"
    sha256 cellar: :any,                 x86_64_linux:      "de16e77e3bcd9876976edc30022a1b7d5ec99fd2c3c6d89241f6b40dd278d303"
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
