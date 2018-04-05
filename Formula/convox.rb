class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180404202349.tar.gz"
  sha256 "b54ee7dbb227e208c4badf6e3518c4800d8d33f5211ade17efa2b02ff93f0897"

  bottle do
    cellar :any_skip_relocation
    sha256 "d63f436c9600f866820147b34c2907ef7688e91f4b42564e11a2319ff3adda8e" => :high_sierra
    sha256 "a67570aaa6bc5a5ec47b1ff1e886903cfc9d8a384cef024e4a89ff4bea90dbaf" => :sierra
    sha256 "0085726f77d7952d080f861c7b09b798c483ea714d319997c95e84737ffa4465" => :el_capitan
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
