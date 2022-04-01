class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-5.0.0.tar.gz"
  sha256 "a99b7edfb52c8195b2de4988844d32d73be6426f6cff28408250517b238fdef9"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a679961194e5c4b3a45031c6a0a0fa41eb8a500811329d11cfc907d826f21b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6913b0f16a0a981287cf450c19f5428d85271e082efe501be35e4917e3ce6b84"
    sha256 cellar: :any_skip_relocation, monterey:       "2422e8c30aa2f163e3c49e90d3a309d9a95b02847c2765e8dc4d93941a713c6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bc3a2a8874038f0cc702891be56a226f27047be3c4ce9464ae81211349f8e28"
    sha256 cellar: :any_skip_relocation, catalina:       "9a80c94fb0526d79d79796168eea9c2362742f4fdffb7342cbbb5d8fd35da906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e87da091b4ac1ee232d7203af1f9bd99018c31aa901b1ea19ac6bed45b8dea02"
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin

    system "go", "build", *std_go_args, "./lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
