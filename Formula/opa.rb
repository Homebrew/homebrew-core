class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.30.2.tar.gz"
  sha256 "d3a9f68c980b56f84a18e1a476d210696c3fc907a3b2c090be9391fe5c7e3eaf"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eeb63d08f1d1f1d01cb9cfd5e85b082cceb2674fa4ef06ca18ede03a0c83490c"
    sha256 cellar: :any_skip_relocation, big_sur:       "13071f269a9ba686a6780c7cb1befec5ed8246c6536542c2358c083cf0621bf0"
    sha256 cellar: :any_skip_relocation, catalina:      "360292793a0eb634893e5c91c05c96744ebbefa2d50ceedb4cd1afc54243456d"
    sha256 cellar: :any_skip_relocation, mojave:        "96aeb97862d790e0a1ac3b6196af444bd253ac2658300e682fcc743b3b358394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52d8eef4cd192be339967691fd70111881dba25518976e7ed8cb598032c08b0f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
