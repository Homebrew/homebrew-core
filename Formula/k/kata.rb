class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.19.0/kata_0.19.0_source.tar.gz"
  sha256 "f36b33f08bf7134cbd78a582ff04e6c72e93b7ddd80a647636685d2806b9e5bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eed418c042dab2504b6bc2bdd5b73930b6d26ee010ec9518f9365ca614b1bfea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eed418c042dab2504b6bc2bdd5b73930b6d26ee010ec9518f9365ca614b1bfea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eed418c042dab2504b6bc2bdd5b73930b6d26ee010ec9518f9365ca614b1bfea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d01b0c1b6abb9f13d0ade5ec19e0e290ebd1200fae669f576541be71b0aea933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de9e4608198981dba987b81877bf900b05951fef8ed1838fbb1ac08a86926e5f"
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
