class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.8.tar.gz"
  sha256 "d0f9edf2a5671695de1b81af5f897b76edbbaf4fed036767d45a87bdbcf5eef1"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0d2b57562ed082742216e8576a8d02cbc9301285aac0159909e611795f3e83b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "6543f05aaa8b1ead7d70a379daca89bce7cdf17f5ba32b751ec6af9d836cba9a"
    sha256 cellar: :any_skip_relocation, catalina:      "2f68ee710074baa934c3028d8240110053d37c16edb9f813667b879254548d39"
    sha256 cellar: :any_skip_relocation, mojave:        "0f84af117d6d6dd0224a849875a0cecf27de241654ef7d69fcf76d4bc09dd518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7464ec1bd96ad6ae17ad1bbce764b3392bed09da440cccddf70f23f8a0534597"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
