class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "53b4d6192f1f2038d12db4fcf115e817ca708568cd27af5884b6f727caf9ffc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b57b9ebe03b3afde02bcbbd9e401eb03e6e1bc83c3a31550261f168b0b2ce9c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b57b9ebe03b3afde02bcbbd9e401eb03e6e1bc83c3a31550261f168b0b2ce9c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b57b9ebe03b3afde02bcbbd9e401eb03e6e1bc83c3a31550261f168b0b2ce9c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad3c8b8755e27ad6b2b03a2cec3a44c48dc58ce030939c6ad25987a02266cf3"
    sha256 cellar: :any_skip_relocation, ventura:       "7ad3c8b8755e27ad6b2b03a2cec3a44c48dc58ce030939c6ad25987a02266cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee13bb018a21a4b21f4cc93c689c2aa2d7b45cfde157345db8f58b3412f73f5e"
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
