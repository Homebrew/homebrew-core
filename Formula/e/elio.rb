class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://elio-fm.github.io/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "c8a43ff0fd8ffcbbf48296b6d26ad02a123e882cbfb832a0a9c2e3c00576109b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "807404b9e3fbd80a628abf1a0dbe505f769fe3becd209d6edd6333faeb8c2ca8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52d4237a2cf080e0ec2b9884459acc4033d9609e1620a617188910de6d59e969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "747cc30a8d3a2871dc03ed0ab80c405e92b4a7bad15f32c0975f235ffd234ff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "06e00c4e686308a0506545c2e08af227b218a5c3264d28d85157f96b5b2e14f5"
    sha256 cellar: :any,                 arm64_linux:   "5ba230012be99c102dd22beea2a7a6dd32f433fe777b39cef2d3a8c595244804"
    sha256 cellar: :any,                 x86_64_linux:  "c1a48a60f6c2b499969a77980a140cd49225e1c851d3e9b5887e61863b9beb47"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    missing = testpath/"missing-directory"
    output = shell_output("#{bin}/elio #{missing} 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
