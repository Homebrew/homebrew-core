class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.9.0.tar.gz"
  sha256 "bd1d21630b3ff1b5a9b0b5fe402e7d48bef453c96c119f276ed1bc1569e410fd"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d87f84c7338df31ef33f97ba871d5af7e865b4e03fc63fe540ea0b55d5dbd0f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "c43c884649f494503a1bc484a73bedadbb90bfdab14ea8f4cfef7b9910aff799"
    sha256 cellar: :any_skip_relocation, catalina:      "b92853f8301a594402872e3095b70cd192d2688bfe600bfb42fadc2ad38ae3fa"
    sha256 cellar: :any_skip_relocation, mojave:        "79a432a262ffa4b158680dff95f99f45d8335653a1fbd6e760fce1e20db04aac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=#{version}"
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=#{version}", output
  end
end
