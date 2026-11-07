class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate.git",
      tag:      "v2.1.1",
      revision: "e28b0fbab7c16cb0e95e5c05e8c05c98910da9d2"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c05808a09d4c1d29fcf1e70a6a8f3cdab07070a6503b16b8209c45e3f62baa7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "694078c893cbe70a68fc18656a286169f9f8e6f787d0619455805b9011f604d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2659f026a220fd368d9f90f1678755a496834e993b389d4353a46c6b1d69d90e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "13e4a237bb6f79d807def84947ae94f1bb796d44f0ec1c82a57b4a27f7dbf61f"
    sha256 cellar: :any,                 x86_64_linux:      "be231df830ddced7358e3d838cce8a94a5905e59d82b175808f3d9e323a29031"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  allow_network_access! :test

  def fetch
    system "pnpm", "with", "current", "--dir", "ui", "install", "--ignore-scripts"
    system "go", "mod", "download"
  end

  def install
    rm buildpath/".version"
    (buildpath/".version").write version.to_s

    system "pnpm", "with", "current", "--dir", "ui", "run", "generate"

    ui_build_path = buildpath/"internal/controller/ui/ui-build"
    rm_r ui_build_path if ui_build_path.exist?
    cp_r "ui/.output/public", ui_build_path

    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"ffmate", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    database = testpath/".ffmate/data.sqlite"
    (testpath/".ffmate").mkpath

    args = %W[
      server
      --port #{port}
      --database #{database}
      --send-telemetry false
      --no-ui
    ]

    preset = JSON.generate({
      name:        "Test Preset",
      command:     "-i ${INPUT_FILE} -c:v libx264 ${OUTPUT_FILE}",
      description: "Test preset for Homebrew",
      outputFile:  "test.mp4",
    })

    ui = "http://localhost:#{port}/ui"
    api = "http://localhost:#{port}/api/v1"
    pid = spawn bin/"ffmate", *args

    begin
      sleep 2

      assert_match version.to_s, shell_output("curl -s #{api}/version")
      output = shell_output("curl -s -X POST #{api}/presets -H 'Content-Type: application/json' -d '#{preset}'")
      assert_match "uuid", output
      assert_match "Test Preset", shell_output("curl -s #{api}/presets")
      assert_match "<!DOCTYPE html>", shell_output("curl -s #{ui}/index.html")
    ensure
      Process.kill "TERM", pid
    end
  end
end
