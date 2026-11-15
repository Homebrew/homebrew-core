class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://github.com/hahwul/dalfox/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "9613d8266b7fa7348829590caed0af567ba7cd0137075add913d8037066dd9dd"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e3972ab205b9177b5ccdec97f60e0bf825efad16ac10ad90c5d4861fcf59de4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6bd20b84c5031e5c13742b8fb960e9875ef67da01bcb33b6086bdb6e186dc75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "733c353c8820b9ff3862e504e9dd363456584a57d4f6811ba71369287aa8e322"
    sha256 cellar: :any,                 arm64_linux:       "f617c06a4f778fa825c6043257b093ea206e91f415f1ecab3b5d68b02c640e55"
    sha256 cellar: :any,                 x86_64_linux:      "4b52f28bb775e03e8022757dff261a1043c71380c6f305b6772f5f070aa88666"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1", 1)
    assert_match "scan completed", output
  end
end
