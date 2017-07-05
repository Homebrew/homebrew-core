class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170705142908.tar.gz"
  sha256 "16e754a5e45bf99eb905f0f8bf7f47b8ebc8cdbcf024be5353f1f8f544a37066"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf5c66b381c1f6c249f42b648bb60c7d54365125b22f72913dc8f83791e6464c" => :sierra
    sha256 "a3fb87386e061de3a645f0ff56036b21664d468efe8024d300b9e68671ea7486" => :el_capitan
    sha256 "526d17e81f5a8d1150b32e22b9f91e6f12889eef9397b28ce575e8c7e3cab8d0" => :yosemite
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
