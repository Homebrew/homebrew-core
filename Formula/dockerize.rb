class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/v0.6.1.tar.gz"
  sha256 "c21cea3e6bb33a2e280c28d3521b8f177c78e875b475763fcb9bd7a545e21688"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8228e79369f2d20e2635792723af7c66e1a9c63c0f5c20e87ec507c9d705337c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d280e3d9e80e0a78e577fbb3d2695b2019c29ab3b21329f199fd87946c0debc"
    sha256 cellar: :any_skip_relocation, monterey:       "ee74a57cfcd91e053e24decaa70d0ebb8e2e732fab238876b94921fe5898d72b"
    sha256 cellar: :any_skip_relocation, big_sur:        "64f691e93e6c7413cc6ade249cf76c7daaa7225e3f347c1ee6897990025ab172"
    sha256 cellar: :any_skip_relocation, catalina:       "31eafaba901153d80f1cf5e9fafb07834595413720c288cfd926f3c376a460a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1008e402b919a326216cb934aae95c45094717812c800a7e1dd5e09aeb5151b9"
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
