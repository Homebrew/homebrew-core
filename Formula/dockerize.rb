class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/v0.6.1.tar.gz"
  sha256 "c21cea3e6bb33a2e280c28d3521b8f177c78e875b475763fcb9bd7a545e21688"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10060ad4ba540100f4edb5a27cbcea5bb1c8620e5676a682e3952070697f2fb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90853c4ee626e2cb95c4e18ab3d3b855c7f9202483730f7c7e626f7f59922d47"
    sha256 cellar: :any_skip_relocation, monterey:       "8304f9e05708e2acf5417664e42de4d1d9791592988505151c5061ae5cbaebbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eae1414df1ef1786653e916ce2690e6636e89ff6e20bb0b1588b3b87f8b48a6"
    sha256 cellar: :any_skip_relocation, catalina:       "dee3a4b81443d1ceb646f6c945b05162b704df6135501c618d428f54f7f741fa"
    sha256 cellar: :any_skip_relocation, mojave:         "78278dc4fcb9699bd3e16f6a07371b369674e05b868e89bbaf80f86cdcb423a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efb59f2e819a96effb506bdd11f488f77106407628330ba5ccf3b9edbe14697c"
  end

  depends_on "go" => :build

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
