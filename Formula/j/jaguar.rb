class Jaguar < Formula
  desc "Live reloading for your ESP32"
  homepage "https://toitlang.org/"
  url "https://github.com/toitlang/jaguar/archive/refs/tags/v1.50.3.tar.gz"
  sha256 "d3ce88689b316cae68f52a74cd8d3644be736ff3d8f2f6635c0cd2790d72b942"
  license "MIT"
  head "https://github.com/toitlang/jaguar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e052bb835cbf63e00b24e4d1340c2b2baafbbd0aac7d5547ea2a9831375bf111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e052bb835cbf63e00b24e4d1340c2b2baafbbd0aac7d5547ea2a9831375bf111"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e052bb835cbf63e00b24e4d1340c2b2baafbbd0aac7d5547ea2a9831375bf111"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc869fa3693126de9a69d7c22d065b9835fcb45e1c5e03d5c30d4631a0394343"
    sha256 cellar: :any_skip_relocation, ventura:       "dc869fa3693126de9a69d7c22d065b9835fcb45e1c5e03d5c30d4631a0394343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb8600e7dac9b0a31a6adf44cfa655e91d761e20bf7457259530a9767b00aae0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildDate=#{time.iso8601}
      -X main.buildMode=release
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jag"), "./cmd/jag"

    generate_completions_from_executable(bin/"jag", "completion")
  end

  test do
    assert_match "Version:\t v#{version}", shell_output(bin/"jag --no-analytics version 2>&1")

    (testpath/"hello.toil").write <<~TOIL
      main:
        print "Hello, world!"
    TOIL

    # Cannot do anything without installing SDK to $HOME/.cache/jaguar/
    assert_match "You must setup the SDK", shell_output(bin/"jag run #{testpath}/hello.toil 2>&1", 1)
  end
end
