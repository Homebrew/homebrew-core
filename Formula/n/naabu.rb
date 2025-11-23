class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://docs.projectdiscovery.io/tools/naabu/overview"
  url "https://github.com/projectdiscovery/naabu/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "a6dee678235ee42bb874ef42d9f0c873062c85a35829ecfc9f204c0c654a3b44"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4cd29c1aff268f682da3ae652fff806ccaa433c1740f4f4f949bff404c6c6c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d59fb207f3d532fe02fedabe790f01d3d46b61bdabcebd21c53a93d7e13ec8ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f767ad436f3345273795a103b9647fe54d3b4fe79e276c7ff68f17aeeb7c48e"
    sha256 cellar: :any_skip_relocation, sonoma:        "21ab98b9bb7c747b1d7db756354db7f3a2468509a5c78ed91b3bb366f82ff6e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "038a957b3ea8af0e777f7c31afb329bacff07be8a7543abf4aae12375aeab0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3909df2136b4905f915935c59a5d9904742f079a8b3c810161a1095ec998af4"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")

    assert_match version.to_s, shell_output("#{bin}/naabu --version 2>&1")
  end
end
