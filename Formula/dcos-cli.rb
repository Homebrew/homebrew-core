class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.mesosphere.com/latest/cli/"
  url "https://github.com/dcos/dcos-cli/archive/0.7.9.tar.gz"
  sha256 "5bf909eee73566631e19f554160540b7d5aa4693d2d8858a057cd86bd2875b78"
  head "https://github.com/dcos/dcos-cli.git"

  bottle do
    cellar :any
    sha256 "96c9722c152028ed02e76bd782c50722fb6469677e0f4d59e351f5da36802855" => :mojave
    sha256 "290b09815b412354a29728fd37bb1217192bf6e91913dbc43dbc798f237a6e5a" => :high_sierra
    sha256 "052ac256bd597fce2dd43ea317f493ec2f355407a525261bb3e6fc8561ce27d4" => :sierra
    sha256 "f682f24ac66465cc1367e7fe30be40e430f420d8d65a0e7b4fcecc65ae6cad8f" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "wget" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["NO_DOCKER"] = "1"

    ENV["VERSION"] = "0.7.9"
    ENV["GO_BUILD_TAGS"] = "corecli"

    bin_path = buildpath/"src/github.com/dcos/dcos-cli"

    bin_path.install Dir["*"]
    cd bin_path do
      system "make", "core-download"
      system "make", "core-bundle"
      system "make", "darwin"
      bin.install "build/darwin/dcos"
    end
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=0.7.9", run_output
  end
end
