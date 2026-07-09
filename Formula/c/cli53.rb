class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "4dc4c3c552a0e045015d734d9505e120db879157cbaa3540f3090559df001ce0"
  license "MIT"
  head "https://github.com/barnybug/cli53.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edc75f2077dc433ee2886b10767d869a845424f143336ce03c78bac05e4b1dba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edc75f2077dc433ee2886b10767d869a845424f143336ce03c78bac05e4b1dba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edc75f2077dc433ee2886b10767d869a845424f143336ce03c78bac05e4b1dba"
    sha256 cellar: :any_skip_relocation, sonoma:        "c00307f73333ae8ef0ed14d2648eacf4794805c28c19712a4227bf23a7eed4cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7b72b2ce4d48ae96913fbfa2d7449d116aab8a3a1b3423458e9830a570378fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4b69d17652cad4fbea72d16035dd14025491c1b2f5c451e6525ed60c620bd49"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
