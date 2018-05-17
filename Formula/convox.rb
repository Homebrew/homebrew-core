class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180517121111.tar.gz"
  sha256 "890d1b802250b97118be55564d60759bf3822656901593e352809f419f3ecb7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3b7745393cae9d96c9da4ef9c4a1298e28c6f8d7cba5aee85892605226c6e54" => :high_sierra
    sha256 "b93ce9e78567ecb5ca41aa7e931134c9041b4c92d664e9f0faeba14acebe2b82" => :sierra
    sha256 "ae39cf4c92347e2cf5b60ae87370ae571caf986d446a1740b552ad390484f788" => :el_capitan
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
