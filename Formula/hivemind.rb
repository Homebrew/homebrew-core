class Hivemind < Formula
  desc "The mind to rule processes of your development environment"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/v1.0.2.tar.gz"
  sha256 "8c04202253fe6fe5630c26820174f6fc578fc81dd7b38910d37dfa4df6bae017"

  head "https://github.com/DarthSim/hivemind.git"

  bottle do
    sha256 "1b4fa624a89134ad5a7297dbc6c8db6ed412257499fc356fc69da27f98f0c18a" => :sierra
    sha256 "2c5b41c72bdb00649305da748c2728c7cfc8c8c4d269cd16c6d5f0cb691fe081" => :el_capitan
    sha256 "da26893b9eee6d5ed41a6727aa00d72ea7899e248ba6a76d213c331f293d25fb" => :yosemite
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
