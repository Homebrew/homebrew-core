class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "d62e8fdc6028a79511a87bb494a5edcf4649838f11a34580741d7f016db64b1c"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b7495c405b9ff38fe3041ccc17ab1f090305c981ca263777f7544630a5787b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b7495c405b9ff38fe3041ccc17ab1f090305c981ca263777f7544630a5787b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b7495c405b9ff38fe3041ccc17ab1f090305c981ca263777f7544630a5787b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "05ddcc3075781788cdac815b70427153d4e2bf8b664403485689372363191eb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45f21a8cfc691c008b73ad1210701e78c302f4d013d7d52457a49eb461f9be28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87d968e89225144d98eafeca74c2b03d8e6175f595fb65d1b717851cca4def0c"
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
