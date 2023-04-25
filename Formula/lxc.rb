class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.13.tar.gz"
  sha256 "932b3ccdfaa192926aab820283a74eb28244a31276d3d1b0763191adfad9ee3d"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48cad8ee5b5b619bc602fef6feaa3710f4eedb2f9b220465eb4c2891e1997060"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48cad8ee5b5b619bc602fef6feaa3710f4eedb2f9b220465eb4c2891e1997060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48cad8ee5b5b619bc602fef6feaa3710f4eedb2f9b220465eb4c2891e1997060"
    sha256 cellar: :any_skip_relocation, ventura:        "6af27bf54af8a0554148d54e6568dbb952853f1c79256a9aec6b0887c57db9e3"
    sha256 cellar: :any_skip_relocation, monterey:       "6af27bf54af8a0554148d54e6568dbb952853f1c79256a9aec6b0887c57db9e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6af27bf54af8a0554148d54e6568dbb952853f1c79256a9aec6b0887c57db9e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce2ae199c862db5cf525315844a7f904d1c4cd0d084e131e5aa5b7666f3514f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]
  end
end
