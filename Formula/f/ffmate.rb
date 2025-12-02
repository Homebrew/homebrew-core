class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate.git",
      tag:      "2.0.15",
      revision: "7623e465367bc09fdfdc08ce6b21b7d6de1999c1"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f1c90cd20211ca3465ff81dba069dee99467513812355db250a0d6be18d1e1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95a84eaac525fc433499d5d72bcd08ac706127d8d2bab605faed242fcf889a9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "071fd32cb185344c9d8733efa5e49741696330173826fafb35896d7612e4cffa"
    sha256 cellar: :any_skip_relocation, sonoma:        "95cc36a49f86a87f8e9f54de173c394fc67cde4f529195c974c0507e2bdad6ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3faa4f152cbbbf776cb4fa0f28d7cb46e1512294fd5e241db5b7e5f2926c013b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1869034aefa7b67ae099e7614fafcfbadb854cffc2da1cd524b3d6ea6a14d3"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    cd "ui" do
      system "pnpm", "install"
      system "pnpm", "run", "generate"
    end

    ui_build_path = buildpath/"internal/controller/ui/ui-build"
    rm_r ui_build_path if ui_build_path.exist?
    cp_r "ui/.output/public", ui_build_path

    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ffmate", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
