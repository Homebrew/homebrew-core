class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "a97c362d54d3d2a05111fac780b6beb62db818ae1e92a33f53576c59267146e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d82dd6ec2febde6778b102a41c5e35f169bb2bff02861e390a53ef999c61d2fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d82dd6ec2febde6778b102a41c5e35f169bb2bff02861e390a53ef999c61d2fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82dd6ec2febde6778b102a41c5e35f169bb2bff02861e390a53ef999c61d2fc"
    sha256 cellar: :any_skip_relocation, ventura:        "354af6e477139615bc48a0d67c146a787b52c36bf6cf7ecfd31bf7fabd789eb1"
    sha256 cellar: :any_skip_relocation, monterey:       "354af6e477139615bc48a0d67c146a787b52c36bf6cf7ecfd31bf7fabd789eb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "354af6e477139615bc48a0d67c146a787b52c36bf6cf7ecfd31bf7fabd789eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b609395810b46bc353642ac06edbf54adcd52b75777b3a1d31f395a64ce596c"
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
