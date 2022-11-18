class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.3.0.tar.gz"
  sha256 "a9fe0efc94b72ca11003940145ca4d48a8af32e5e9593d1a53757dd2eccacbb2"
  license "MIT"
  head "https://github.com/DarthSim/overmind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8212d5d52e66cd05b5081350d04e6e16482bcafcbc1ee99645f2c9876dbb0a36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4841af6b8c882b52029d7c7a58bc0d5534bfb7f53f1b33b76d980f6197db954b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b96582ea0b7adb01d40b4429beaac118bb090bb856f3579a9a63c100cbc00546"
    sha256 cellar: :any_skip_relocation, ventura:        "92fe5bd6251fb3273d1aa0ab581c5fbc847919f04d7be3ac4019f09ec4b262a9"
    sha256 cellar: :any_skip_relocation, monterey:       "ad3705236fde66360596bee1567ba806420d5b215a0ce51d206679ba360583ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a1f67aff79d61c0ba2b46fa108ba1fdd8bf35252e897c9b81e54fa66c6d1b79"
    sha256 cellar: :any_skip_relocation, catalina:       "281b468e00c93a48d08a2288365a86cf3c4726ce9ab26777c07e903895c503d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "162e1a133b3a55c485c8149a375b442bc3e01ef1306f7f28fab381f7559225d7"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    prefix.install_metafiles
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'; sleep 1")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
