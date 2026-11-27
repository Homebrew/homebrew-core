class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.24.0/kata_0.24.0_source.tar.gz"
  sha256 "e7c96426a35b20b6bf7ce044692a2391bd4a9108a66dd43f75d3067c1a991378"
  license "MIT"

  bottle do
    manifest_sha256 "5fcba6be1265d58994d6defbfc702b9d46e5696483c115f3b54704d261ac2e0b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e626f8ae90bf930b5a985d7f4afdbadde2292dedb792621e020e4f09e1e14b2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e626f8ae90bf930b5a985d7f4afdbadde2292dedb792621e020e4f09e1e14b2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e626f8ae90bf930b5a985d7f4afdbadde2292dedb792621e020e4f09e1e14b2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6bee3e1142b247ef35e908328f525f044c980c76f624699a6e352d61616eff61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c5bb98e201bf63136ebfeb4ceabc7b4b6f8cb4159427aca7eec139960005313d"
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
