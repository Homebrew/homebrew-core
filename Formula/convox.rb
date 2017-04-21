class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170420220644.tar.gz"
  sha256 "e38c814820556565292d9c45f4e14d5eaa7df46bc9934eaa1f526c0399d9e5e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a1297a37730c6349ffe20f16a1a8f765665008c1e15958c779556de35cadd33" => :sierra
    sha256 "86e9ccceca637d1ac6b99269f21b2c99135e031d3cf71aeb60dbd13e3254f7d8" => :el_capitan
    sha256 "1e632651449dc45c4222a553d8b24ba969f93e1494fc5eb7911cee42a7445906" => :yosemite
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
