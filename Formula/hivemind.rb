class Hivemind < Formula
  desc "The mind to rule processes of your development environment"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/v1.0.3.tar.gz"
  sha256 "005e816289c467de2f9a2b0f37f4f685b5aea7c25167c3fdafda3da68fc76e80"

  head "https://github.com/DarthSim/hivemind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c30727e8182de3464b652267eded12de9a6d8c78ed133e696882cb7a345e48d" => :sierra
    sha256 "56e8604449bd4c51398cdffa0cab6a354eb47583fac73e9a6f745a4a1b1804b7" => :el_capitan
    sha256 "dc7e1adc1ed256809185241c1df25664392e54c0b5dbd9a1a3b73402e4831553" => :yosemite
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
