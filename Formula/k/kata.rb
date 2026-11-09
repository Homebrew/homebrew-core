class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.23.0/kata_0.23.0_source.tar.gz"
  sha256 "51db4ca405595a99c92cb57702f233e4f054365b6c0ff58e99c7a4499c3e19d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab8ba5bf731708a694566c49bcf5f802c3a289c994a49ee0922432197f842451"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab8ba5bf731708a694566c49bcf5f802c3a289c994a49ee0922432197f842451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab8ba5bf731708a694566c49bcf5f802c3a289c994a49ee0922432197f842451"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "92aed66aed7dd0cdafc4e7052bb5352ae6d703aa5b2f9ef65f2683d10173e214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "44584cd9056ac9dcb1f922180290c7fe6bb6727966ede988cf16eb6031a433dc"
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
