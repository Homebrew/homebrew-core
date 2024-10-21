class Goresym < Formula
  desc "Go symbol recovery tool"
  homepage "https://github.com/mandiant/GoReSym"
  url "https://github.com/mandiant/GoReSym/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "f5bfd29ca10336a13b63f28cc7523ae75288a06d8933ef9f6783e30b9920f0d7"
  license "MIT"
  head "https://github.com/mandiant/GoReSym.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9e5356d79abca5a087a9b300a0b3380e51dd628edf60ef41d68bd0eb0bf28a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9e5356d79abca5a087a9b300a0b3380e51dd628edf60ef41d68bd0eb0bf28a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9e5356d79abca5a087a9b300a0b3380e51dd628edf60ef41d68bd0eb0bf28a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b406c1ff5e8eba933266227f7efa0143ce4750afa7cd9cb8f62774616b329ba2"
    sha256 cellar: :any_skip_relocation, ventura:       "b406c1ff5e8eba933266227f7efa0143ce4750afa7cd9cb8f62774616b329ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff0c0b39b08a22e4fb8d13876551d466fe51ad1c989bf0c7512999b47bb1fac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/goresym '#{bin}/goresym'"))
    assert_equal json_output["BuildInfo"]["Main"]["Path"], "github.com/mandiant/GoReSym"
  end
end
