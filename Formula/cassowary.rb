class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/v0.11.0.tar.gz"
  sha256 "60d1bc68b75a59bc5511fd33eb77b14acd735887c74af1bbc4ea68badd271606"
  head "https://github.com/rogerwelin/cassowary.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8f7d3def722987e81c22df1ea898ed28973476fc309988756c573f0372b381a" => :catalina
    sha256 "10de18f2c186dffe62c5407365f5201379b0f3da3bc37eb9e0b60fd465959c19" => :mojave
    sha256 "2eb13fb3ce1f657d59791152266497761fc5c6a562c49f96ec6b7cf81c3099aa" => :high_sierra
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
