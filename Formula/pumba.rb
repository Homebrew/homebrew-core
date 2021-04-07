class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.8.tar.gz"
  sha256 "d0f9edf2a5671695de1b81af5f897b76edbbaf4fed036767d45a87bdbcf5eef1"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23ea7c27073d54ac360deae32dd52388dcda30a72ca7e3f7c34fd715533d9c45"
    sha256 cellar: :any_skip_relocation, big_sur:       "ab72f222b8eeaadf48320af5f87db33697cafa4a519010d200a377f16f81cef2"
    sha256 cellar: :any_skip_relocation, catalina:      "9aacdeac788678e480042779b159e00f80f06886d89c5a61f601741349a4cefa"
    sha256 cellar: :any_skip_relocation, mojave:        "32e9cf47edec277ec8ec83e8a5536018133ab7ba8d2532dc7fdf8c8e624bafc3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
    prefix.install_metafiles
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")

    on_macos do
      assert_match "Is the docker daemon running?", output
    end

    on_linux do
      assert_match "no containers to remove", output
    end
  end
end
