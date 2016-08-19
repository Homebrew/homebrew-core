class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20160818150650.tar.gz"
  sha256 "da665756fcb63afe1f8c73c3bebd626be82b1d7d71e40683fd91d0af72c2c00b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c1a122c7ae95116bff7daa94973ce7257476f2a3c6d53e13278b264c4bf6dfa" => :el_capitan
    sha256 "bc5ca125f1b12d2a6e654a8b8bedcc55faa4e5d5ece78aa04f2eaa15e89c103c" => :yosemite
    sha256 "d52fb8ff45792b9da02f2b29d723519f02bef6e96f6929fda94b06d08b9c0e43" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}", "-o", "#{bin}/convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system "#{bin}/convox"
  end
end
