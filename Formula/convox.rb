class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180416200237.tar.gz"
  sha256 "f8f960e2d28520c3ed71e67fe704e885b20172d5980d2b74d629768fbc4c2444"

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
