class Exercism < Formula
  desc "command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v2.4.0.tar.gz"
  sha256 "789e7674dd9dc921df204df717b727120608cc5bab6f384b9fd32b633a8f6e63"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d09883462e90d34ec20989e7e0006ea499782210f6e2693d26ce167bd3066f7" => :sierra
    sha256 "f87c5b77e12e2d155a945b450e85e66b86edd63f14f9efbedea0010ee7077f78" => :el_capitan
    sha256 "137c8b5f8d3381af017969bb382eca0b1b329a0d3b2ace129f1f5c61ab06590d" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/exercism/cli").install buildpath.children
    cd "src/github.com/exercism/cli" do
      system "go", "build", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism --version")
  end
end
