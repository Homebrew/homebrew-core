class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "875288e6cb1c5a2ca6c576508be96954874156acd6f0d6b08e3adcf71e697c3b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf4e73922f265b8676271e67c13326e9e9da385ae9ad4454de9fa1760c546ef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa30f49ea259f80a5c4a257a614967e49c8f4532ccf51daed08cd67d085a35de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dd6ee2739dae1b7364eae6fb5a5afe3af8dfd163a773316635bf2fa26e4eac2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e80d4b9b6f7cb4cbb637bfa3f7d1170b9bfcf22816a106931f815887c8bb5aaa"
    sha256 cellar: :any_skip_relocation, ventura:        "e4f0ff158139622cd5b52ddc998a7a1c46485dec9958a52e03754c6282335d6d"
    sha256 cellar: :any_skip_relocation, monterey:       "1b125f0a621c52df1229021c978d5ab70c00f2217cdff07eecbaf43054dec61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89595ae6fd5a8f399eb4dd00cffe438fe44073ddefb954f2811e437dcb5b281c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
