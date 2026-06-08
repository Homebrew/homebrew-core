class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "431e8f17b43a56c5dfd667a13a8d77d4201ef551345e4008ab30b25333f66e3a"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1850165820717335089619abc5cddc112158efb7bb530e800d94ecc0a642e3d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1850165820717335089619abc5cddc112158efb7bb530e800d94ecc0a642e3d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1850165820717335089619abc5cddc112158efb7bb530e800d94ecc0a642e3d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7f92601c3e91de64922d44c485bbb58077ce58578db540e1f7c1c89597e8520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb6646cdac24967fc24d93ea743b8ee4bd1ba9939d1f5b0ccbf89e04df3d9b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5436d635687a80680206ccc1601978913d7ab91c0d3aabb81392c85b27874838"
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
