class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.1.1.tar.gz"
  sha256 "eaea8d3de0587296c992404baff55b6274d2bb239a9d8012fb59d08c7f6b475c"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3dca71dff8086b365e8b2b314827a01739c2f28847c7eb7402ffa80687acda3" => :catalina
    sha256 "ad0552f203ce9c42ac9f84e6caf0778a26ab2eeff3834010e7954952a8b9fbc7" => :mojave
    sha256 "8ab423bd236183063a06a1256943173dd0a26df53d410fa98ebf2a751f948ee1" => :high_sierra
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
