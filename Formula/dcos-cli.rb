class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.1.3.tar.gz"
  sha256 "cc423272e08a15d30e13c60b2245350c0b7d027649a6a01d44a58596a5ed8b20"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "885608448ee10b76a0605100eeda5b1597998b9f81597813bba4e7b32115d6f5" => :catalina
    sha256 "f7116290594e24bac141f8e8689832197804373a6558c55159eeea79ce56a15c" => :mojave
    sha256 "1255e7628a35b8afac17b55f34fa5e0d24cbcb14c155648bc39c7c579c91ef9f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["NO_DOCKER"] = "1"
    ENV["VERSION"] = version.to_s

    system "make", "darwin"
    bin.install "build/darwin/dcos"
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=#{version}", run_output
  end
end
