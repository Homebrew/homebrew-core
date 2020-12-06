class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.7.tar.gz"
  sha256 "5da828d47d7d46305fc921445ad47d9825a1d54f09b8be8a01ff2095c804fe2d"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d76ae3115bf1f8013c51df4823d6713bec47338735153f7a61c23170cd328e5c" => :big_sur
    sha256 "16134112a01371f366f64ec7ffaf992f57957d2eff9102afd4e9a822eaebb09e" => :catalina
    sha256 "2ae012db84d882725c825f4269e813bc133244ead9fa55dd7bf13b73c9565bfc" => :mojave
    sha256 "9ba93aa20ff6d7233190f82a10962ae30d43fe57bd403ac457796c3ccd98ace3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
    prefix.install_metafiles
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
