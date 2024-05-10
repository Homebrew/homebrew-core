class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.1.tar.xz"
  sha256 "935869f90948aff1f27d60de6fd2ea39f1c9b479b2cdd4023d8927102da4e455"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad69843fdd4b685426a1cba1c458c795bf8183ad88e21bca0dfc9fde5711329"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fe1dc8bb9ae35a61585d525223fa2d367f12ac428d434e23d7cf0aae4ef2469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "600fda1a7e4d8544e6bfa01ebe4679666545e9eb923311b0120c66ad47a3db59"
    sha256 cellar: :any_skip_relocation, sonoma:         "f3b73b498158b6b766a06385ce655caa23b9fe45e35b3aa7fad064dcc75238d3"
    sha256 cellar: :any_skip_relocation, ventura:        "853a029e8df16f0ed4397b802b7f91e2626cadd3c7274558c5843fcdcad0b74c"
    sha256 cellar: :any_skip_relocation, monterey:       "dd2911c8710aca783b1c4e4d21775543b94ee4f1b4917a8192431cbadc3a2fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11aa856f27c6cfde03923bdde557f622fd4e4add7b196c7b02963e744d37dd16"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
