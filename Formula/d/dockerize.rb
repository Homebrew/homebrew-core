class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "b06e64264d5e267c37f383034fb487e6777c7e8cd04cfbd0830a50af47f93c2b"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0b161cb30622dabf4afdafc49715370921ab14799ef7b383a5ab9def661563b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0b161cb30622dabf4afdafc49715370921ab14799ef7b383a5ab9def661563b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0b161cb30622dabf4afdafc49715370921ab14799ef7b383a5ab9def661563b"
    sha256 cellar: :any_skip_relocation, sonoma:        "15309a6b39c26ef26304b7d5e5078e6576e58eb55b46bc165f28ec164f306532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81bb9b9581c048b526a36e2c9e1c656f20990ed200b8530d592b06c86337afa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9cdc334727728bb3b112a142780619c7e5acb69c376d84c8ff8a8ae0c41c87a"
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
