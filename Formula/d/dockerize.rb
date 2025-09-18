class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "34926f5c736544b0c754a1a6de05c2ac3338033f77e872a2a4bcef55667e7509"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "144fa8dbd95fa3b7679cff214defbc5ad5bd18e49a996250896698192d4f2dfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bce2724a44498ef7a8f3af75fe83f9c9f0b655e808af100aeab35aba133d97dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bce2724a44498ef7a8f3af75fe83f9c9f0b655e808af100aeab35aba133d97dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bce2724a44498ef7a8f3af75fe83f9c9f0b655e808af100aeab35aba133d97dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f718902815c4f7fde3f6c6860c485dd62db8b8388cfa8898d52c2d9331293876"
    sha256 cellar: :any_skip_relocation, ventura:       "f718902815c4f7fde3f6c6860c485dd62db8b8388cfa8898d52c2d9331293876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "550dcae60f0801cc80da4f86ae9b741c95a6b655f09bd7b33bf2dcdaf2d4deff"
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
