class Exercism < Formula
  desc "command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v2.4.0.tar.gz"
  sha256 "789e7674dd9dc921df204df717b727120608cc5bab6f384b9fd32b633a8f6e63"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8438ef7230bd147cebdc0eb41760eadda35e6cb381ff71e8a9b79027f44050d" => :sierra
    sha256 "f668c0fdbc732fbe2287706f4d663e707283790c315408840efc88b76a905e51" => :el_capitan
    sha256 "2c5c0c11a9bafd2d989cd4b0d305a513132e02ee0b3a927f2611d31d0b727e74" => :yosemite
    sha256 "9e36695bf4391faa6de406a3f79bfc257cfdca6a33d6cf861a817402f796b23d" => :mavericks
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
