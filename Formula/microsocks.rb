class Microsocks < Formula
  desc "Tiny, portable SOCKS5 server with very moderate resource usage"
  homepage "https://github.com/rofl0r/microsocks"
  url "https://github.com/rofl0r/microsocks/archive/v1.0.3.tar.gz"
  sha256 "6801559b6f8e17240ed8eef17a36eea8643412b5a7476980fd4e24b02a021b82"
  license "MIT"
  head "https://github.com/rofl0r/microsocks.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "291f03d019abfd665fa4b4fe413f4e85bd9b77b1d1f2b1c9dc3d179378b54401"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7b5b8fa1a3ab00cb45bb1de97e67d53ac12bc04a5c9366b287eec91ab290400"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c609eb83c72039c8c826ba7377758738a5889d82951da4c61c4598245e7e280"
    sha256 cellar: :any_skip_relocation, ventura:        "46a56ad581517235d64822fb680616aaa500cd6c206d31cd09ddaedc23cef702"
    sha256 cellar: :any_skip_relocation, monterey:       "ba6beacd676cf505ea4e865f0c6f664f4d2cdce2fd5ed338c34077b9c92522ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b9ad2d9aaca92f430fe651b86a7a83323624f812c083264a7479ddcd29241b7"
    sha256 cellar: :any_skip_relocation, catalina:       "aa5872429094462b4147aa020e0c0d79ad93e7a58c347b4c20af967f937f2e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8477f5acb8120732c5bda2642a694a40ac93bdc7aa0b744b600e2d1761fcd6c6"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    port = free_port
    fork do
      exec bin/"microsocks", "-p", port.to_s
    end
    sleep 2
    assert_match "The Missing Package Manager for macOS (or Linux)",
      shell_output("curl --socks5 0.0.0.0:#{port} https://brew.sh")
  end
end
