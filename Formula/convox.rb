class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180728174119.tar.gz"
  sha256 "2e48f282bd6d55b8795e23ea84ad7e7c981585c018af34ea651f773083bda9f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "a568f28224d773900ce9722079121911c6062914c41272d1a9aed105e2303d87" => :high_sierra
    sha256 "550f4c1c665d2971565efb9c35c0662395e8533954bf3c9ea594706cafad23fb" => :sierra
    sha256 "c8b132853366954f1f69a9419bf8bd2a18e02b2d5403e70c5fdc23295c02697f" => :el_capitan
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
