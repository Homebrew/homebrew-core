class Qq < Formula
  desc "Multi-tool structured format processor for query and transcoding."
  homepage "https://github.com/jfryy/qq"
  url "https://github.com/jfryy/qq/archive/refs/tags/v0.1.5-alpha.tar.gz"
  version "0.1.5"
  license "MIT"
  head "https://github.com/jfryy/qq.git", branch: "main"
  sha256 "5539959db9bc08cc7f72d9e4c152b007133d6393932cc0a103332d4acf2a979b"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfryy/qq").install Dir["*"]
    cd "src/github.com/jfryy/qq" do
      system "go", "build", "-o", bin/"qq", "."
    end
  end

  test do
    (testpath/"test.json").write('{"somekey": "somevalue"}')
    assert_equal "somevalue", shell_output("cat test.json | #{bin}/qq .somekey -r").strip
  end
end
