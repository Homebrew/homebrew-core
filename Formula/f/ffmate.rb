class Ffmate < Formula
  desc "FFmpeg automation layer"
  homepage "https://docs.ffmate.io"
  url "https://github.com/welovemedia/ffmate/archive/refs/tags/2.0.7.tar.gz"
  sha256 "8db66a36dad1fea14d58c19aaec16defec6cd49453fe2f1b87b6a17c41b18db8"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ada2f1341858169046fd95386178a649b2d5a182c873b5bdd2dcab8201bec443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a03119e59ccbdcf05ab9ac13f16cafbb921b82c48383ff361777d139cdbfa0bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9378e582287b260eb61c8aef45d8dc8d27df01a2fe09eb1cff2eb7ecf8cef529"
    sha256 cellar: :any_skip_relocation, sonoma:        "e31337e2c5df3186e764724163e699457dc5cec1b9308c398146f0d1ce1c838d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0f9257b89d0e4198ef04c7150415ec452469bfe786b1f178b8007242e5a7e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0483596a62d8d073800a186731639190eb818363be6e30163d19aa8a7775ae2d"
  end

  depends_on "go" => :build

  def install
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
      --no-ui
    ]

    preset = JSON.generate({
      name:        "Test Preset",
      command:     "-i ${INPUT_FILE} -c:v libx264 ${OUTPUT_FILE}",
      description: "Test preset for Homebrew",
      outputFile:  "test.mp4",
    })

    api = "http://localhost:#{port}/api/v1"
    pid = spawn bin/"ffmate", *args

    begin
      sleep 2

      assert_match version.to_s, shell_output("curl -s #{api}/version")
      output = shell_output("curl -s -X POST #{api}/presets -H 'Content-Type: application/json' -d '#{preset}'")
      assert_match "uuid", output
      assert_match "Test Preset", shell_output("curl -s #{api}/presets")
    ensure
      Process.kill "TERM", pid
    end
  end
end
