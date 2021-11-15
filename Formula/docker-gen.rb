class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.8.0.tar.gz"
  sha256 "3d969c32d1a612d44c8193422649b375ea9cea8d78a044be463d58fe128c525a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dc799e86dfa297d94d05de294564a04acb28a95bac9871ace56a69f1d3a19a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eacba5ac36276e0aa5de4f71b3d26a11f5e00f89f10bfb81ecb29415bdfa1cb3"
    sha256 cellar: :any_skip_relocation, monterey:       "208331344c9feaa4404957d4f4f384b2ca0788320a38e626db541d522fc883c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a490c2b1f72c1855d117c7dd88fb0214e4dd69ad1409e940eb7bbb116cedd89"
    sha256 cellar: :any_skip_relocation, catalina:       "34c5a01ca13bcd79fec6287375b95832455b886d20eb8f799513a0c189523509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39cc3af1ef20613483280f3785c29ff8694eeb04016c9381c1dcb462ba5ce5f9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
