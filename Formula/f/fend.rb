class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "79fd768cb1e28cd691c7da7fc84eeb0b41f43f5bfca92fff4137c7596cea4bff"
  license "GPL-3.0-or-later"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2475f65ef8c9562b66cc8051d62565eead0d0db28a5a93f2885de8c228f95cf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4db91cc6c114825e2b1e355d9fecddf070fe919d938d8f08b2c7ac1b09edc281"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd5475baf8f3434843f30ee8e6b20d6329477f5b485b7ad9b017ec0c29f13310"
    sha256 cellar: :any_skip_relocation, sonoma:         "54562abfe4d38be8a8def010ecb9fcff28936b90bee4ccd016f4dabb5dd9b63f"
    sha256 cellar: :any_skip_relocation, ventura:        "f1c6c277151eff954854dd7606b3c0a599c40413ada524cdb0ce0e18c08ac790"
    sha256 cellar: :any_skip_relocation, monterey:       "4f035a636c2e582d2af94d2ca72a1d6d5cc3fd0a86985db06924bf9515c5bc5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e542cb0ecc5dd1bf0d9111f692fbf3b00367e2b1bfafbdf76edaa6b64c68be1"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
