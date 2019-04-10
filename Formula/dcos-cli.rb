class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.mesosphere.com/latest/cli/"
  url "https://github.com/dcos/dcos-cli/archive/0.8.0.tar.gz"
  sha256 "bc6f3ab1e399c8b26c72839ac8c8304290913450c70ee69335acd8459de30e5c"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["NO_DOCKER"] = "1"

    ENV["VERSION"] = "0.8.0"

    bin_path = buildpath/"src/github.com/dcos/dcos-cli"

    bin_path.install Dir["*"]
    cd bin_path do
      system "make", "darwin"
      bin.install "build/darwin/dcos"
    end
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=0.8.0", run_output
  end
end
