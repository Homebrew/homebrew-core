class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate.git",
      tag:      "2.0.15",
      revision: "7623e465367bc09fdfdc08ce6b21b7d6de1999c1"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecefc5f9a5662ccb5d9d314d6172f28c54d396f9d7bee368bd82ee53e3123cb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8f974e7ac6c2cb8163395d6d53a2f80b53ea74bb8f9aef6af5bd559ed3f567e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc20c7fb2be650edc6af56126694af8f9a29acd3fb53cd1857dccd18a36c701d"
    sha256 cellar: :any_skip_relocation, sonoma:        "03d859753e3f4ec6289131313445c5c264c42777c7b2bb4e6c869e16e3cdb686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56a9b6a3a8ec9c52685da3b7af4ded7f3050fd9e66aaa278f016e389f156e2ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04ba3e70eddeadc4cf99137e7c2b8ec964ea938c2dd1a6c8258e93f00cec04c6"
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
