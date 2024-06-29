class Qq < Formula
  desc "Multi-tool structured format processor for query and transcoding."
  homepage "https://github.com/jfryy/qq"
  url "https://github.com/jfryy/qq/archive/refs/tags/v0.1.5-stable.tar.gz"
  sha256 "2ce422a2fa1f101bb93690a9115849f7325986ab5732e31a59c811607821c876"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaa9c320ae5265565e88cf0339877f1e23dbb36da77941f93dfa8de16fa3c56d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaa9c320ae5265565e88cf0339877f1e23dbb36da77941f93dfa8de16fa3c56d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaa9c320ae5265565e88cf0339877f1e23dbb36da77941f93dfa8de16fa3c56d"
    sha256 cellar: :any_skip_relocation, sonoma:         "913c71c96b456b77a5b17076195966d0ad01322800ac4c1906f01c5194bba95f"
    sha256 cellar: :any_skip_relocation, ventura:        "913c71c96b456b77a5b17076195966d0ad01322800ac4c1906f01c5194bba95f"
    sha256 cellar: :any_skip_relocation, monterey:       "913c71c96b456b77a5b17076195966d0ad01322800ac4c1906f01c5194bba95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2d16913d5404b69e86887081d1d8b762825722573325dce59e49762fe1f22e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d2d16913d5404b69e86887081d1d8b762825722573325dce59e49762fe1f22e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end


  test do
    (testpath/"test.json").write('{"somekey": "somevalue"}')
    assert_equal "somevalue", shell_output("cat test.json | #{bin}/qq .somekey -r").strip
  end
end
