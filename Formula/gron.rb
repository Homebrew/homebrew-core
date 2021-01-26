class Gron < Formula
  desc "Make JSON greppable"
  homepage "https://github.com/tomnomnom/gron"
  url "https://github.com/tomnomnom/gron/archive/v0.6.1.tar.gz"
  sha256 "eef150a425aa4eaa8b2e36a75ee400d4247525403f79e24ed32ccb346dc653ff"
  license "MIT"
  head "https://github.com/tomnomnom/gron.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7851170e1feed7c87430f7af735f193cf295b5a4116d0f177296dd8fb000815" => :catalina
    sha256 "8250d3b6d9acc5bf1700a6513ab9df0df1a3e5660d2f984a4a903c234e6cd555" => :mojave
    sha256 "7838ab1c751a11027f31b7b4dac4f7a83402b04a7eef522edeb15735846dfd81" => :high_sierra
    sha256 "fa5310f4ac25091387f24e5dd4bb0364db432ebc9f3273da371cbd35116af09e" => :sierra
    sha256 "23c3378ea69d5936b6966608942a0769c4adad0cdeabb9575e8b811b9b6c3a26" => :el_capitan
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/gron", "{\"foo\":1, \"bar\":2}")
      json = {};
      json.bar = 2;
      json.foo = 1;
    EOS
  end
end
