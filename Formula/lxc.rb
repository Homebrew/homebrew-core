class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.3.tar.gz"
  sha256 "0d174a09fa749cbde58393bf5a6eef5f682b3bf0c1bb2847462f395c8e656995"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3f866d8080cba59e0400a926da9700649f34ca9d3c5c0db84b1ef099d540995"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cd9131559630718e091d1e6627d2240802560498e2cea7e0a78107a9ea40246"
    sha256 cellar: :any_skip_relocation, monterey:       "013deaac3864091bae422cde994bf7309715cba0709f067fd9f985fc41edc10d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce00c73de335e549e142b61158b9394db51a1cd36a721085e07838c05d4336db"
    sha256 cellar: :any_skip_relocation, catalina:       "e724901e8f6caeffb264202127904966978c6a14c47c5be0d23a2440112b63a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a779e710cb7055e0e96507c14967513dc20ff7587d34378c652ed92b87aeff7"
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
