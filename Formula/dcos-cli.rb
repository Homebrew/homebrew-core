class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.0.1.tar.gz"
  sha256 "717aaf1e6c54f4fe383a0b6a5faec334954ce6581ab0b86a87704e0e9e89ea2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9939f27e458ce26e436b84d4845e6b51cc15ffe196b21a8662a13ee47df9314f" => :catalina
    sha256 "d2a341cace761a125074a43b726ae8870dc13ae7c56181a034386480ca95a6eb" => :mojave
    sha256 "b301d70712db5fef0e290b75ce8f4011f2e47379d4ac2f79501f5b7d1949ec95" => :high_sierra
    sha256 "0bfaa7d808a3df6e90e28d9d9f7be12cba925c9abdcf6272545e95cdd291579a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["NO_DOCKER"] = "1"

    ENV["VERSION"] = "1.0.0"

    bin_path = buildpath/"src/github.com/dcos/dcos-cli"

    bin_path.install Dir["*"]
    cd bin_path do
      system "make", "darwin"
      bin.install "build/darwin/dcos"
    end
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=1.0.0", run_output
  end
end
