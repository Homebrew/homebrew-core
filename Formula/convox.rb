class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180415180827.tar.gz"
  sha256 "39807ce3eb30e0e73a1b6db8f8218c4f2e0ac2375079a5e693d08cd0bb85d302"

  bottle do
    cellar :any_skip_relocation
    sha256 "406f32f946f79f8091691419179139af395bd76ec3d976b6e25195127a196aa3" => :high_sierra
    sha256 "4f28bb31f3bc3bf136b21f5000e82ede9a30cbf59a500481692cb778ae42d2ed" => :sierra
    sha256 "67dc5329e5bd4d2ee5f7df3b38d81fff4a52fe0a82a8118eda80bd8b67d90553" => :el_capitan
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
