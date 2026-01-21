class Proxify < Formula
  desc "Portable proxy for capturing, manipulating, and replaying HTTP/HTTPS traffic"
  homepage "https://github.com/projectdiscovery/proxify"
  url "https://github.com/projectdiscovery/proxify/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "a156d8094ac5a31bc92029c1a9e02300caa5e2f189dc13949410d792e9f4e63c"
  license "MIT"
  head "https://github.com/projectdiscovery/proxify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0115217c88f10cfbdc76745ef04ae0d7f1d663cbd081d57b1fb1a4da7819fe68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e2bdfdedcdcb3ebddd535df0f187dab19b794869793bc5f0a096412423122b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f512065276786dbe49e669c2bd6dda009952c5650817d7fda48659a7e99c08d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55d02209f5e215cc15c57df775866a9f95de9de9c797acce7ca87ba95c715aca"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0b34a5b8faca1288c434e2181c24ad5770f8cbcc02cedb05f37fbe04442257c"
    sha256 cellar: :any_skip_relocation, ventura:       "4a80fa274bbc79f69b63d71aa4a823a0dbeaee02f802a30a01cc98b3b4cb7869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47ba9d44e07adf3fc672bcb94daf2e9d058ca432862206a9e115972af567c7ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ae504f9d04fce697580389190a075d1707b2d658e6867cb12c5dc2e4c9d86e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/proxify"
  end

  test do
    # Other commands start proxify, which causes Homebrew CI to time out
    assert_match version.to_s, shell_output("#{bin}/proxify -version 2>&1")
    assert_match "given config file 'brew' does not exist", shell_output("#{bin}/proxify -config brew 2>&1", 1)
  end
end
