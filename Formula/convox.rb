class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180517121111.tar.gz"
  sha256 "890d1b802250b97118be55564d60759bf3822656901593e352809f419f3ecb7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a05073ab9e72cadecd5882b378bd77f8d0b192721a6da086d67aa512d41a739f" => :high_sierra
    sha256 "8925179300def7ff430afe8f4a001b34cecc7bed5bda036d5a5912c1b3fcb4c2" => :sierra
    sha256 "ffe04c08c6e40c77320a72b7f079f40ffbc71dc629c01f4467871cf8214cae70" => :el_capitan
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
