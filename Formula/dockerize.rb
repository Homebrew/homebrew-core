class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/v0.7.0.tar.gz"
  sha256 "c39e756cd2d43341dd01645f2a100437dcc7c91cf5bfed5751e71a4804575a7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2c5ba6437590435bf77b6b5b90819acddf8ab499944ace62258c3fee7f69070"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c5ba6437590435bf77b6b5b90819acddf8ab499944ace62258c3fee7f69070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2c5ba6437590435bf77b6b5b90819acddf8ab499944ace62258c3fee7f69070"
    sha256 cellar: :any_skip_relocation, ventura:        "e04719aac68f9656ec01acd5add5e521ea013f03f9fce382d7d5c42f20459b7a"
    sha256 cellar: :any_skip_relocation, monterey:       "e04719aac68f9656ec01acd5add5e521ea013f03f9fce382d7d5c42f20459b7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e04719aac68f9656ec01acd5add5e521ea013f03f9fce382d7d5c42f20459b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2b4bc44d532320f78149b4e7e0c2b223d17a562865b6d777144e698e4ff6071"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/jwilder/dockerize").install buildpath.children
    ENV.append_path "PATH", buildpath/"bin"

    cd "src/github.com/jwilder/dockerize" do
      system "make", "deps"
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.buildVersion=#{version}")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
