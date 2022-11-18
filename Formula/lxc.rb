class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.8.tar.gz"
  sha256 "998c8360ef24e0c56835af317e9d6f1f69f2ba136c0c9f77b3d17986368c7ed9"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23d1f435c9fa0b9d582e3e2f96d83f8ea55d5242ec6ae63624ee56cc334dd343"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54778274258aba0b1572bc145649505f55dc87d6e143a1e4b6ca49ebed50ba17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22afea16bb5bb5e2cde6fd6ab827d8c352781200be143c5f77e1fc01016023f4"
    sha256 cellar: :any_skip_relocation, ventura:        "e5ef86d4d1c49e9cf3bfe03b55472423c33ddab2477b8f6e0f927481ba4bcf0b"
    sha256 cellar: :any_skip_relocation, monterey:       "4f9e01a32a6a5685867278a12ebe75e7ecff8c5014c838c5506fadaea144e8a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae4c9fd0338f8d67e4c14fe50f9e8c87554d9fc4dd5f637e409231ede2f07377"
    sha256 cellar: :any_skip_relocation, catalina:       "e128d6bd31b34a35deb34c082ffc2951e879b00b10d7db50ca02137ba055a22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88b62aac6a393835dec4f1228f924ee8e8caf8b4916769898f5592b973eaaca7"
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
