class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli.git",
      :tag      => "v0.7.0",
      :revision => "07d1041389d1cb0b8a9e69cda40e3afa762bbc72"
  head "https://github.com/kyma-project/cli.git"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/kyma-project/cli/"
    bin_path.install Dir["*"]

    cd bin_path do
      system "make", "resolve"
      system "make", "build"
      bin.install "bin/kyma-darwin"
      mv bin/"kyma-darwin", bin/"kyma"
    end
  end

  test do
    output = shell_output("#{bin}/kyma --help")
    assert_match "controls a Kyma cluster.", output

    output = shell_output("#{bin}/kyma version --client")
    assert_match "Kyma CLI version", output
  end
end
