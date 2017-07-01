class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v2.4.1.tar.gz"
  sha256 "47d6fe998e4c8f900b249f427292b3c268addfddccd1ebc6ce07ca0d7e390622"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a36d2e4e48bf887cb1b8fa9369e0cec990721a73aa49b702d27ce47aba58bcb7" => :sierra
    sha256 "f3a0eda8fc9aab0217da024264686d1486d700e0773a73234b201ff59bdc8ced" => :el_capitan
    sha256 "919a7febefd72157e0c25e81e6f9d34bd88904ecc5e372bcd4c45c1e907016f0" => :yosemite
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
