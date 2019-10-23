class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.1.0.tar.gz"
  sha256 "35aed62b9fee23c96dea835d4022a4ca04d18a8e81d0bc5a6a003e41aaf75d88"

  bottle do
    cellar :any_skip_relocation
    sha256 "004913024b18bff15db109f677059b7978d8711998d6e676fd177e24f5f7e044" => :catalina
    sha256 "1564dcdc6371477863f0d3dc949b7251b143ba3f688c611b527f07c3a0a9b6e0" => :mojave
    sha256 "521a123affe226746d70186894209529be71e3186195e3122bf7fc2dc62e0433" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["NO_DOCKER"] = "1"

    ENV["VERSION"] = "1.1.0"

    bin_path = buildpath/"src/github.com/dcos/dcos-cli"

    bin_path.install Dir["*"]
    cd bin_path do
      system "make", "darwin"
      bin.install "build/darwin/dcos"
    end
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=1.1.0", run_output
  end
end
