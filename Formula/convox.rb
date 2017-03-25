class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170325002636.tar.gz"
  sha256 "089d595d9b14fb9f630c2f5ef38aabbeb365c52093ecd6e67804ab0e00973f39"

  bottle do
    cellar :any_skip_relocation
    sha256 "02b30dc7b96aa95a12dda96529ecb7917cf2a0ed0db4d6ca83de78159c0c986b" => :sierra
    sha256 "892e9ce79b5403b3bd2f16f295cafe867b2202a8fa5b6b3de7400d2d2354f1e9" => :el_capitan
    sha256 "b806a88d1c6b97854ed4e1b4bde08da76d56ea7ba971e0372c3acd5f09f79711" => :yosemite
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
