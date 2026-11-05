class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.21.0/kata_0.21.0_source.tar.gz"
  sha256 "132cd803ffb6393dec9f0f2732788d3b037173ca7abc6f7151b094a3adb80353"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a014b5446994172dd1e86735f08364a54b154e1f520c5da06df72977f5dc1f73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a014b5446994172dd1e86735f08364a54b154e1f520c5da06df72977f5dc1f73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a014b5446994172dd1e86735f08364a54b154e1f520c5da06df72977f5dc1f73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe39021f4eee768fdfde4e5554ad23f2e74582a091099625d6c8b55274814d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "00036f197197ea63c6cc636cb5cefd6d91851ed70a7e1e4c70cbca5e348cd0ac"
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
