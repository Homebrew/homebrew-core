class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.56.0.tar.gz"
  sha256 "170e7b8d0432d5086625f038d2e3a2ed80cf44928192b90452c21e5469ef91f9"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7fe0faf22b49032366f515b73c322f4b11b9f3e8bfc85120bbdf07345eb394c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3b96946d242341f6f06e2efe292ec97b908cc46ec7a332c229fc91684f12f1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ab7ed9fce6d40d6a6bafc2dffdce3a244a67199c6adafbb22e5ea7cb896c3f0"
    sha256 cellar: :any_skip_relocation, ventura:        "69c78c552cd1ec8b8278d86bfa302edcf24d279ee6d7aa135ceb96fc3b142bff"
    sha256 cellar: :any_skip_relocation, monterey:       "db5595a15c50e0301addb6a118e44d59b86e8c38819efb361037a0d660dfd157"
    sha256 cellar: :any_skip_relocation, big_sur:        "007b0a84b5c70e62affd178146062b3ee57a5bcf90498c4ed22a305e7bf7a239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9228d2e1defd79cf20b1d692e04230035a1ead001c262aafe4c334592f4589a9"
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
