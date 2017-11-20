class Hivemind < Formula
  desc "The mind to rule processes of your development environment"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/v1.0.4.tar.gz"
  sha256 "0c8b6bc8e3aef70bc8f5dd1b29db04a48f8f874ee269d3155670e70263d73cbd"

  head "https://github.com/DarthSim/hivemind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56c20cb1f12f1507f5bd9812e1cbd5aa0ba9d6175ca630d77b9ee695544de256" => :high_sierra
    sha256 "9394d7e524f24e97b7c1785603007d61a9f881693120431048cb0738735f499e" => :sierra
    sha256 "b4935d6a93aadeb47588fd644af677cea9dce0f2aaaf6aa7a7b69a1d025012cf" => :el_capitan
    sha256 "f5ae77335095a56d15ebae85def6d35a3b15634db18dfddf4ae5de5e22505068" => :yosemite
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
