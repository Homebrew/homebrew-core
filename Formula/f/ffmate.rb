class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate.git",
      tag:      "v2.1.0",
      revision: "3466e0c6e2b1e4e7a713bd8406a2aca61517ff21"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a6f096c8773b0deadb6da0d4fb3ddd0f2f163e77dc9e4bc1f4a3699e99bf0b89"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93fe148eaff85aef678d9090c51cfde519456a6a105f6b689e8a79f05ac9ad8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c3e8b33b1c60df4fc4e01a22b6948462353c5001843d344776aab91ab3ea77f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2d5ab24739a7fbfe78ba5cbd9c5df8dc269f14de3cc9945699035abf06f8f92"
    sha256 cellar: :any,                 x86_64_linux:      "cbf79b83cafd97544d0fbe3fe1e909198ba4854b8d9169fbbd3580876a87a4b5"
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
