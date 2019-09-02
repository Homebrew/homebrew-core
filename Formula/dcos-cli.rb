class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.0.0.tar.gz"
  sha256 "04326b1feae6844cc893029c5d86588f8a796d200edd0f03e8c4a57dae733552"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd4e092a54674868edcfb46f90b8d1e0d83c2f5c1ca1750b84eeed390a4b766b" => :mojave
    sha256 "fb0548c2f3983d2d7dacf74681e0453c6628215ddfd58f0aaccb81f6813850bb" => :high_sierra
    sha256 "fbba6c02bd1004e1f8eb64c2055e9227a2da2239b76b26704c082f711c0e3f3a" => :sierra
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
