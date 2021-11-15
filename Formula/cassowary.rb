class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/v0.14.0.tar.gz"
  sha256 "385232478b8552d56429fbe2584950bfbe42e3b611919a31075366a143aae9a9"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d98b3b6c308986895c5fcb0966331d895035239aae504a7df75dcf7401048772"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "648d2b294a0a5523a9941c54d4399ba7af9574d00535c27560642e4df77cd883"
    sha256 cellar: :any_skip_relocation, monterey:       "a01fed38f90e43630a2fea77a4bd55925a89b9c2e83be754db8e6265479184ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf5c5498ca3f7eead7d7cd3526d968d20e546dc6c8b58d40f3a18cf8e5175406"
    sha256 cellar: :any_skip_relocation, catalina:       "fee06e4f638390a52a6a0b3ce3f2fb833620ba383871fb03b90fe8b90366787e"
    sha256 cellar: :any_skip_relocation, mojave:         "f83cb625a473f40918a7eff32b1f2615862faf40868cd7aec8283d6ae7abb9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd87fcbb01eb4a4aff7099a3d5b2aa88d80221657342ea3380213d2dbebb4c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", *std_go_args, "./cmd/cassowary"
  end

  test do
    system("#{bin}/cassowary", "run", "-u", "http://www.example.com", "-c", "10", "-n", "100", "--json-metrics")
    assert_match "\"base_url\":\"http://www.example.com\"", File.read("#{testpath}/out.json")

    assert_match version.to_s, shell_output("#{bin}/cassowary --version")
  end
end
