class Hivemind < Formula
  desc "The mind to rule processes of your development environment"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/v1.0.tar.gz"
  sha256 "7dde50f8f68214929f53c380ffc6311b39aad071a67bb6d94ebc3e641f78083a"

  head "https://github.com/DarthSim/hivemind.git"

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
