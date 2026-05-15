class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "6577354c57d60a01312de8499e0bc0f404393aebe1f9fc174c5513eea1a7da46"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2a2b4fb24423379f738c42d71b10652edf11bf0b52df35054c741723cf3ec0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b14d143e0422cba404424b1e56c8df34262c7220247e0f53b1cc69679dafbca7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1404d8d01b637ccddce3e331a8afded950bdbe8c4ff7873d921c578c7398a2fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "88571975507601815c48563d1a63fd129d25ad6ea3cfb95ea91293ba1d7ee5b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "095acb7eb30325e32bddd291144df0f5ce6ac66817a84c539dcf1af708e01d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aac451c805ef30bb90dab07166cd259e50d78c5c94bde2534001d6cd03b87512"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
