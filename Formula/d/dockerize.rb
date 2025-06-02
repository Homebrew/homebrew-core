class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "73e1d74e4548affc8491c678b35560468998462c677c8be555c2a24657b4222a"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d9678f32f8aa1cbb9ab471d09d55191d4c0d2a04af7888fed7512d37ae042e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d9678f32f8aa1cbb9ab471d09d55191d4c0d2a04af7888fed7512d37ae042e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d9678f32f8aa1cbb9ab471d09d55191d4c0d2a04af7888fed7512d37ae042e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d911cdb52483e88d898e261ef49ed47cb3922edaef5b7c85c58c233244ab392"
    sha256 cellar: :any_skip_relocation, ventura:       "9d911cdb52483e88d898e261ef49ed47cb3922edaef5b7c85c58c233244ab392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5564e1ba66e1b6b143c2187d573f8accf0fc33f55bc69b22264ca9c8e423b2ac"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
