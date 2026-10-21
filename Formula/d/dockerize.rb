class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "284de769d51bd97da1c4f0ae2f20fc5194385b0a820d893cb4e92bd8e1a29511"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f1b3c9af1f245561318ac47c4c3eb96116f55695b1b8c6cdfec33fa6bf2efb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4f1b3c9af1f245561318ac47c4c3eb96116f55695b1b8c6cdfec33fa6bf2efb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f1b3c9af1f245561318ac47c4c3eb96116f55695b1b8c6cdfec33fa6bf2efb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "03db1a79afd112d06d4b246b5a7e0c333b15e102b044560a49c15129f37ea2da"
    sha256 cellar: :any,                 x86_64_linux:      "5dd4a90caae346f3937e36bc1742acee0b81c3192969f14939d9a50d200858b4"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
