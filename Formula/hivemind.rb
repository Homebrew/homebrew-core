class Hivemind < Formula
  desc "The mind to rule processes of your development environment"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/v1.0.6.tar.gz"
  sha256 "8ca7884db49268b7938d0503e7e95443cb3a56696478d5dcc2b9813705525a39"
  head "https://github.com/DarthSim/hivemind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e76b38e91f2a8143a01b72d7428e4b869fcffb9a9332cd20d89a3d667058fa72" => :mojave
    sha256 "04b2c5ea90cac6a2c552e7209650bfdaa3a16b43a6bd2f8492c1fdcca852a7a6" => :high_sierra
    sha256 "bb2ac3328d179d26a6d02cc952b9efb7352aea0f9f8faf6c45c84e29ceb5e298" => :sierra
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
