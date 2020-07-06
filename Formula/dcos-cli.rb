class DcosCli < Formula
  desc "The DC/OS command-line interface"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.1.3.tar.gz"
  sha256 "cc423272e08a15d30e13c60b2245350c0b7d027649a6a01d44a58596a5ed8b20"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f98490af0a9ce9a22e7de6f764d887342e11bbd25ca70131e2987a93131170f" => :catalina
    sha256 "d38aab9ff56007a19cc5a6e16546ac852b10a08d9b951c32dc36fd10642a15c0" => :mojave
    sha256 "a44dadc1335fa9f20ef25f10cd6a6ef826b7d34cf20de7261b3e67d5c86f3474" => :high_sierra
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
