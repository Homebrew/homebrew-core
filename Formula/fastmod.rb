class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.4.2.tar.gz"
  sha256 "5afb4c449aa7d1efe34e0540507fc1d1f40f7eba0861b2bb10409080faeffc4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c5ccf3c98e3738a67b978db815621d4d23be5d9f08d4db91e3a9ef480457470"
    sha256 cellar: :any_skip_relocation, big_sur:       "b87d5d5cb5726da1f18a2ef57659640ff2edd5d9e2ec9a65ae01848a88c7c7de"
    sha256 cellar: :any_skip_relocation, catalina:      "6416944d1320d2188e05fcb0c725a6aa06d73fd76015414d43a8e21d6efb848a"
    sha256 cellar: :any_skip_relocation, mojave:        "fd06122965f7b06b05356363c0483c204c8f0053753324d1355720ad2d111249"
    sha256 cellar: :any_skip_relocation, high_sierra:   "90c4d5b4217b91c14fa4a7726192960ebf45fc04cd5699ffab9173eed6d6fc35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"input.txt").write("Hello, World!")
    system bin/"fastmod", "-d", testpath, "--accept-all", "World", "fastmod"
    assert_equal "Hello, fastmod!", (testpath/"input.txt").read
  end
end
