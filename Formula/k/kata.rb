class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.21.0/kata_0.21.0_source.tar.gz"
  sha256 "132cd803ffb6393dec9f0f2732788d3b037173ca7abc6f7151b094a3adb80353"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25199114a52bc55783a6ee20e1b368a1dc03c8020401bced20c1d29f5fd9461c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25199114a52bc55783a6ee20e1b368a1dc03c8020401bced20c1d29f5fd9461c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "25199114a52bc55783a6ee20e1b368a1dc03c8020401bced20c1d29f5fd9461c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f63940d3b3fc28710267b7635578eddd6f857276c9a3ea1012d11add9156faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c39ff30c972c33bcd0a93c22cb75ff66d3e69cedd54b3d225a1ad054995921f6"
  end

  depends_on "go" => :build

  # `test do` block needs network access for `kata init`
  allow_network_access! :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X go.kenn.io/kata/internal/version.Version=v#{version}
      -X go.kenn.io/kata/internal/version.Distribution=homebrew
      -X go.kenn.io/kata/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "-mod=vendor", "-buildvcs=false", "./cmd/kata"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kata version")

    ENV["KATA_HOME"] = testpath/"kata-home"
    ENV["KATA_TELEMETRY_ENABLED"] = "0"
    begin
      system bin/"kata", "init", "--project", "homebrew-test"
      system bin/"kata", "create", "Homebrew test issue"
      assert_match "Homebrew test issue", shell_output("#{bin}/kata list")
    ensure
      system bin/"kata", "daemon", "stop"
    end
  end
end
