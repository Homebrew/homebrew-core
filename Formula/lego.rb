class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.5.0",
    :revision => "2a1cf86439539feffb06dabec295eb0593457bf7"

  bottle do
    cellar :any_skip_relocation
    sha256 "55f126dcd47073fec006993ce0103b00b84b0858763de66e07b8e03106d48d67" => :catalina
    sha256 "10f0e438f98066f5326bb5adbf58b75e9eb1ac128acc8b46a68276e6218b6dc8" => :mojave
    sha256 "d3d2b8383f59f713b659b30c0459fb1d3b4c1b8eaf28b7201952887bb4bc9bff" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath",
        "-o", bin/"lego", "cmd/lego/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
