class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "192c142ab25893c7a1e8a135280d8e72f05f12b56c1e2b5d932946707ec68c6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22a49e6780e8e00a054aaa35c6749d21095d374eac84c5c773ff549b38adae4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22a49e6780e8e00a054aaa35c6749d21095d374eac84c5c773ff549b38adae4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22a49e6780e8e00a054aaa35c6749d21095d374eac84c5c773ff549b38adae4a"
    sha256 cellar: :any_skip_relocation, ventura:        "8ab1eff297eb25f14338b89b7bd198978b3541e619203fa92ef2450b0045e098"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab1eff297eb25f14338b89b7bd198978b3541e619203fa92ef2450b0045e098"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ab1eff297eb25f14338b89b7bd198978b3541e619203fa92ef2450b0045e098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02c820b472202d7146338d7c94989edf2ce8f8c6223abf57f688224a9f92cc0e"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
