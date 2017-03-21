class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170315195000.tar.gz"
  sha256 "9fbfae20b789503d6d7b27c67e0c85bbadce5bab7161037b1af20ab30ab3a688"

  bottle do
    cellar :any_skip_relocation
    sha256 "e91c7075a2052c78630ea02691cab5bd9a280c6e97b8cd9d77c66be1ad72030e" => :sierra
    sha256 "878a76ce32dba3369ac26f6768c7e87a84c803961553f22df713a546f1961690" => :el_capitan
    sha256 "f781935986b200de1762963d0a61034712517fcc8bd0bb33ad17465050f4fde3" => :yosemite
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
