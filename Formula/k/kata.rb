class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.15.1/kata_0.15.1_source.tar.gz"
  sha256 "ef16e992bce0689fb4eed54115f9ac41038aab027b53e0f4bbbaa41e638d9a4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "867be9a4eb3ae1a97caecb8d914d11395fb8cafd24330c5ee3d3a562501efe80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "867be9a4eb3ae1a97caecb8d914d11395fb8cafd24330c5ee3d3a562501efe80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "867be9a4eb3ae1a97caecb8d914d11395fb8cafd24330c5ee3d3a562501efe80"
    sha256 cellar: :any_skip_relocation, sonoma:        "8950a6ff80d0554d4786accae01fc160abc981acfba56f59d92bacd3721488eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4df8b049e42bc0df052552e344b77be7c85b7f1efb91e4f9f06066aba9d1f2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adf4f5b3e61a37257970f01453ca2dcfac8c3057c177031b3d4ac9a5039863aa"
  end

  depends_on "go" => :build

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
