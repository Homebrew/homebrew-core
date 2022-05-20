class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "b6507b24714dee193bd04be18fe8658531d2b0c0b9f6f060ac6bb387c736009f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b965893a233913bcc6dc0de32a96175be11ece33bb6db69a948be96626fa1f85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5833b5267052b02eea8deb8ae57358388a498bbc691470915feabddd66e73287"
    sha256 cellar: :any_skip_relocation, monterey:       "c67519547af3bca7f8b638306924679b87757e367fd45200309e1f6062cb34ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "1097c8f356642794fb9c0c97882bc85d87b25fca3df3be61eb90a45231b788f8"
    sha256 cellar: :any_skip_relocation, catalina:       "357204a92e944afa92adbf31b721b6ca29c149cb53afec160d320d8ecb2d0a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b905cbbef080a1823a8c8da7a3369832640b7def780d581e48c2c5ead5d53e7"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/powerman/dockerize").install buildpath.children
    ENV.append_path "PATH", buildpath/"bin"

    cd "src/github.com/powerman/dockerize" do
      system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
