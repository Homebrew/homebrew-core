class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v0.6.2.tar.gz"
  sha256 "03ee83b49598f864537aec48ef081d3a79a0cf0f32027d815c37755bf5d31376"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09a71601520e580e8b9ae6c653e6fa7722970e8ebdee32d29733c7abd1aab0ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d18e997593760bca7f35d083b0bb43bba0460cecfeb599a7117c1c492545a0aa"
    sha256 cellar: :any_skip_relocation, monterey:       "26eb31f335d672d4873c87a884b60ce7cf75dceb9a5fdb81c4737ccb3b0d2933"
    sha256 cellar: :any_skip_relocation, big_sur:        "46676eb6c7f8da3b900eaf229e3d100f610248e9b26dadbca0c1c1e752fdb6dd"
    sha256 cellar: :any_skip_relocation, catalina:       "f01578325bfc8f7ce98b4bdd4fde31c6f00ab394c001ff4758e401d7688659e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54aad0272e2803002792311bd75ca06d45aaabeaab4e2e7f492718ca7e098e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
