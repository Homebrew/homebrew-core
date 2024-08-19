class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "264b39888623de9802a2dad0b2a90a4e9d7f4ba3767d0a92d6d00a11e43c7e6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bae9755bf798f1130c7f745c65548708502468146cf860af1b8871f2507576f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32188d89cba40b78509f6b6f4b74d9c7e825b945e95c2bdaa1a48798817dead0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e467ae916e1d8256a256ed2c89a5df2b7719a790a6a4a72bf4976bd68200538"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ce9cd09a2e542d9159b3c1dd3d1b46fe0ff80266b52e491113189cf228fb0ba"
    sha256 cellar: :any_skip_relocation, ventura:        "6f248291f2e8fef5f8189fff5071a7fdf28de142327a2480cbcaa93f7664096a"
    sha256 cellar: :any_skip_relocation, monterey:       "be9c68ea9a68b765a31be15d067a1b427cf7c7fafd3629889332be7d63d6d7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8999aabe358a6404aa3a66f8def810ece5ed29ab35eef46afb2271b5a297eb53"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
