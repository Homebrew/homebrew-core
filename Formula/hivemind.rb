class Hivemind < Formula
  desc "The mind to rule processes of your development environment"
  homepage "https://github.com/DarthSim/hivemind"
  url "https://github.com/DarthSim/hivemind/archive/v1.0.3.tar.gz"
  sha256 "005e816289c467de2f9a2b0f37f4f685b5aea7c25167c3fdafda3da68fc76e80"

  head "https://github.com/DarthSim/hivemind.git"

  bottle do
    cellar :any_skip_relocation
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
