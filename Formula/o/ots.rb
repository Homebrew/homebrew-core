class Ots < Formula
  desc "Share end-to-end encrypted secrets with others via a one-time URL"
  homepage "https://ots.sniptt.com"
  url "https://github.com/sniptt-official/ots/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "09f0b0d7ca44ec8414dbf631009df8c00f4750247c0f9ba25a32f0aa270e09cc"
  license "Apache-2.0"
  head "https://github.com/sniptt-official/ots.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffeff2117ae48bf24cec567453628d77214369023b9d937d34d3255246d48d9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffeff2117ae48bf24cec567453628d77214369023b9d937d34d3255246d48d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffeff2117ae48bf24cec567453628d77214369023b9d937d34d3255246d48d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b10af03d6e1bef384a3cb2a1ea226fe4ea48832134256bf06df70c7042858dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa40dc3ff72b67e6806521e12e4fa957470c2ec0cd3c0d33bf4d16a814c8a421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0433350ebc8f91c651b210a959cc05a81ff3f95d98d4ffcc5c0db5807c9dacc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sniptt-official/ots/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ots", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/ots --version")
    assert_match "ots version #{version}", output

    error_output = shell_output("#{bin}/ots new -x 900h 2>&1", 1)
    assert_match "Error: expiry must be less than 7 days", error_output
  end
end
