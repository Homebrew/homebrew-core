class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "17536538142780aa9cc32dec491778e2fcbf783848ea30cb5aac553ed8e75812"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89742894af0a84651ea40b74a1eb09edc1828c3085f686b01431acb60c005053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89742894af0a84651ea40b74a1eb09edc1828c3085f686b01431acb60c005053"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89742894af0a84651ea40b74a1eb09edc1828c3085f686b01431acb60c005053"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8f6c5e2f602352996933199f8ff180339e4f18baf5508c5d42488b396c0d2f7"
    sha256 cellar: :any_skip_relocation, ventura:       "c8f6c5e2f602352996933199f8ff180339e4f18baf5508c5d42488b396c0d2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "954bc4f8b0982d9174c32f20e4da8ba6b7b17cef89b3e4c99221d05e2b28667f"
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
