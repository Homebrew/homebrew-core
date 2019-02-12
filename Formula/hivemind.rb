class Hivemind < Formula
  desc "The mind to rule processes of your development environment"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/v1.0.5.tar.gz"
  sha256 "75352721e835f87c575b8c259886604cb80dd209f69a06948e1c97a26312a046"
  head "https://github.com/DarthSim/hivemind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "682249a669799d961d5288d8973fc1f4a69acdabbc195371c3b38c71fde96b82" => :mojave
    sha256 "45d2ce2f8a66a697ed67f7e080e47dcd56d3692632e1d07e316455b2a16329c4" => :high_sierra
    sha256 "114b5cd253f904f2222899887a016058922b566ba366ad2d7d66521066e02180" => :sierra
    sha256 "3cf03e49f0b3d8bb2b96966485ad1182c11996bab09d487a1ffcab8967494992" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/DarthSim/hivemind/").install Dir["*"]
    system "go", "build", "-o", "#{bin}/hivemind", "-v", "github.com/DarthSim/hivemind/"
  end

  test do
    (testpath/"Procfile").write("test: echo 'test message'")
    assert_match "test message", shell_output("#{bin}/hivemind")
  end
end
