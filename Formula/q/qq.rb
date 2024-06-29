class Qq < Formula
  desc "Multi-tool structured format processor for query and transcoding."
  homepage "https://github.com/jfryy/qq"
  url "https://github.com/jfryy/qq/archive/refs/tags/v0.1.5-alpha.tar.gz"
  sha256 "5539959db9bc08cc7f72d9e4c152b007133d6393932cc0a103332d4acf2a979b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e8f1a0ae6d51accda2060290bc8e905c71f73912baaa6480634dbd6b0faad1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e8f1a0ae6d51accda2060290bc8e905c71f73912baaa6480634dbd6b0faad1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e8f1a0ae6d51accda2060290bc8e905c71f73912baaa6480634dbd6b0faad1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "29e7849a638dc185551e4fce7375f3279ecc1e4e9e5034b4c28994e5a59c6391"
    sha256 cellar: :any_skip_relocation, ventura:        "29e7849a638dc185551e4fce7375f3279ecc1e4e9e5034b4c28994e5a59c6391"
    sha256 cellar: :any_skip_relocation, monterey:       "29e7849a638dc185551e4fce7375f3279ecc1e4e9e5034b4c28994e5a59c6391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cb1815d1d7cbc88bcf2de921021aaf3b13ef0db782183253682fd87dd5f0b21"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f7edcc9e5407c1ca19978b8be493f528e7a87c9e3a333b976608085c32daa78f"
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
