class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170325002636.tar.gz"
  sha256 "089d595d9b14fb9f630c2f5ef38aabbeb365c52093ecd6e67804ab0e00973f39"

  bottle do
    cellar :any_skip_relocation
    sha256 "db4597030719709c69352d63b72dd374236a22d61af69f9e90fbd1a7fe45a58b" => :sierra
    sha256 "9ed9f11ec89d5cffba6071d4f6a799f6a93da8977618d2868b80fe2ca0a63baf" => :el_capitan
    sha256 "fba844862f7d2ccb3156e54a0f3f91a95038807c86d6d43d8344b291abb1075e" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
