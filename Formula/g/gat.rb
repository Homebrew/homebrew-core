class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "de2815cab3592f03b64144c717df69ed0ecf4c91c579a2145d8bf0730726175a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7087301114851f8c50ded6f925bc1dda4f945805f553e126fc1d31835a7a7d3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7087301114851f8c50ded6f925bc1dda4f945805f553e126fc1d31835a7a7d3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7087301114851f8c50ded6f925bc1dda4f945805f553e126fc1d31835a7a7d3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3f624561e31e01a602889f6f2eb0eede197e8a431150e418ebbb7429a0b11ad"
    sha256 cellar: :any_skip_relocation, ventura:       "a3f624561e31e01a602889f6f2eb0eede197e8a431150e418ebbb7429a0b11ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a1a7556a4aabb9115d76ae03901bc7d68fb5ab20a38dc4030bb92269a26e0df"
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
