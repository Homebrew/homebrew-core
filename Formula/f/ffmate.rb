class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate.git",
      tag:      "2.0.18",
      revision: "a420fb497cf131f97c875fadf35ed622bde5cc85"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4f901c820ac104d4256c8d761f6f5bfec7b621b19327601c314f70e8551296f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba198b85e92f28fceff9a8e5b2c9197f88600d7ec09b8b1a710152a388154b37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5542bce0d6c403efd40a50640f013c964559ee83b54f5ceb6e134cb5e0293bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "df1a62ec4c813fd397ef41dbf05db9a6d635511e0631a992861491ec47d5cc1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31a81ab007e6ecb47a8fb319ad244c84b492173a0c96db789e510549cba3d5fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8871f212b527926a2ff1308b60d9ad8c3ce5e3c47edd793e8614512b9011a0bc"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    cd "ui" do
      system "pnpm", "install"
      system "pnpm", "run", "generate"
    end

    ui_build_path = buildpath/"internal/controller/ui/ui-build"
    rm_r ui_build_path if ui_build_path.exist?
    cp_r "ui/.output/public", ui_build_path

    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ffmate", shell_parameter_format: :cobra)
  end

  test do
    require "json"

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
