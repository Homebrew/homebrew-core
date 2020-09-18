class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.6.tar.gz"
  sha256 "4155f68f38499130a061f4a287137e266446907935d719e6be0a436efdb00d16"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9466bf26ee389122ea63bc3ddd87619052436b81960f321b2ed7eb12ae30dd97" => :catalina
    sha256 "4d6b6d75185c7c1caa95a6e5cd79513ee579f54c5a2d0bb220f2e9f279ebab2d" => :mojave
    sha256 "567508d3166f37c6ec5875a9079d8ac7168ce6c17e1274de9a31f3ee58eede94" => :high_sierra
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
