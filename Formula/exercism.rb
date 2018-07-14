class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v3.0.2.tar.gz"
  sha256 "9a3425fc19ec31a3ecb26a920d808ed813b5dc2e134971b5e8c56ec94dfe1f42"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c10051bcade77a4396dd4624b7d9ef513a2e2b08b4500cc11c8ea8275e34cd33" => :high_sierra
    sha256 "a36d2e4e48bf887cb1b8fa9369e0cec990721a73aa49b702d27ce47aba58bcb7" => :sierra
    sha256 "f3a0eda8fc9aab0217da024264686d1486d700e0773a73234b201ff59bdc8ced" => :el_capitan
    sha256 "919a7febefd72157e0c25e81e6f9d34bd88904ecc5e372bcd4c45c1e907016f0" => :yosemite
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/exercism/cli").install buildpath.children
    cd "src/github.com/exercism/cli" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
