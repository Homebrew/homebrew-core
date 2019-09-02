class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.0.0.tar.gz"
  sha256 "04326b1feae6844cc893029c5d86588f8a796d200edd0f03e8c4a57dae733552"

  bottle do
    cellar :any_skip_relocation
    sha256 "0df34df0b29917746d708c815df4b83ef9aa312f3edc668aaefcb76d7b280c4b" => :mojave
    sha256 "7a062db21c67f105dce39f30b256219f587a6d063349d8731e8dfb780489ad43" => :high_sierra
    sha256 "a4be783cdf1e23318de0fc547467c7955267f8e21486134e567e3492beb243ca" => :sierra
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
