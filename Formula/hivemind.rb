class Hivemind < Formula
  desc "The mind to rule processes of your development environment"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/v1.0.tar.gz"
  sha256 "7dde50f8f68214929f53c380ffc6311b39aad071a67bb6d94ebc3e641f78083a"

  head "https://github.com/DarthSim/hivemind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18fa6c0f6d7df12745a8524fcdc5661cceca8b3a3f76c68d4670747848e30638" => :sierra
    sha256 "0ed5b8e1b27d73d069e12b4d4fb8099c8a3b3c87eb61c871187805d3c2f2ee34" => :el_capitan
    sha256 "8a671c1dc313cd009d2444308d4d97ed70055f399e9a06cf84a01498c498f345" => :yosemite
    sha256 "2eda3f4062198d18fd134ce092a02bed9837246d262af9ead0475986c9870cd4" => :mavericks
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
