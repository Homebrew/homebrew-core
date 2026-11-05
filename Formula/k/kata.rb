class Kata < Formula
  desc "Local-first, federated issue tracker for humans and coding agents"
  homepage "https://katatracker.com"
  url "https://github.com/kenn-io/kata/releases/download/v0.22.0/kata_0.22.0_source.tar.gz"
  sha256 "15fd315bf3f12b36c021c5d1c84950e919ad652da054509ac57a8a20eec56515"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "146bc579bd90164dcf0db91db12ae63f9402c790e014853bceccbcd4c6db392f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "146bc579bd90164dcf0db91db12ae63f9402c790e014853bceccbcd4c6db392f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "146bc579bd90164dcf0db91db12ae63f9402c790e014853bceccbcd4c6db392f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c285654e6a681ab3b2beefde92bdc3332d373eb999e01c729f502f2f8487d982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8809227834676492b8e11852467668887c3297ef8c41c40e8e6e7cf768634804"
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
