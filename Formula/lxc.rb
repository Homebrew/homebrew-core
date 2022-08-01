class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.4.tar.gz"
  sha256 "e234b67c5077d05e22f958e3256bd91f262450545993d0aaf1b4ce2bdb99393a"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac3666284d34cd2a26acbd1607295d5352b752cb07a56a64c78af586de0a4821"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f6cd2e85bb1e22664d0cee8e267f69b203b4e1800a2342596490d1ae265f20d"
    sha256 cellar: :any_skip_relocation, monterey:       "b7a504196ff540b9c88f10132e0429de0e0ec97c2ca0059c63bbe28a164d4376"
    sha256 cellar: :any_skip_relocation, big_sur:        "855fb5b4a1c70323c7b26e586ea4f47c6a95f1d29979fbb884f2ee6f5c714f07"
    sha256 cellar: :any_skip_relocation, catalina:       "c5eef694b1917901a74e685d26d5cf9458a13c59332b017bca079bda58472d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b18243ec2da647b7515453534380861cbb0ddc19da9ac708a18b2cb9c22c433"
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
