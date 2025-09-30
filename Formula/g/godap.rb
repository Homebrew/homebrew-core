class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://github.com/Macmod/godap/archive/refs/tags/v2.10.6.tar.gz"
  sha256 "0f01e933efc7d297f84fc0ddb34a5476db45bfb53d0dc9c0d7784c37d74e9c54"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "082442ffee4a9ff28a968d032b5f719dfafc78478a34f7c3fc6346efb9aea0fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62370a7cb13319a0bb099c2d8ab0d6cc7f5c05e704fa23c0e33af39b6505179f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62370a7cb13319a0bb099c2d8ab0d6cc7f5c05e704fa23c0e33af39b6505179f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62370a7cb13319a0bb099c2d8ab0d6cc7f5c05e704fa23c0e33af39b6505179f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aee3f2cdd062d384e8e1400535510098b75c2ed4fec7e73183734308cdc2798"
    sha256 cellar: :any_skip_relocation, ventura:       "4aee3f2cdd062d384e8e1400535510098b75c2ed4fec7e73183734308cdc2798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2dae7760fd93ea6ccdb0052cbd62ffd58a096c016b997d9faa4478b0b6391ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap",  "completion")
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: i/o timeout", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end
