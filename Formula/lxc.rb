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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5ccc24758e7cea66f9670243c290478d3e49233d13990a32f6ccd01e85d841e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "756e940ab91414ece9ddbfb8e91fa27db1e65323033f318c3fa662d09f833f19"
    sha256 cellar: :any_skip_relocation, monterey:       "b3204d098199879196770d01e9828b81ab3329ff22940b71ec5963d8853e53b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4acd9259f3a05b5968afd9398b1480974c432b3abbece548f53cdfd10b73494f"
    sha256 cellar: :any_skip_relocation, catalina:       "1df61ac1a8497d870029080a7dee88217ded9d8ddc2459216d14ccdddf657578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43e4cf576da39a036a5717c6bcb74df0cebf8d377422033acac7aeefb1a2d44c"
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
