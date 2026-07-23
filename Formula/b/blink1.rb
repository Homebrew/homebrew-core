class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      tag:      "v2.5.0",
      revision: "600da2c6f14e22fecee0e3871463cdab99a68525"
  license any_of: ["CC-BY-SA-4.0", "MIT"]
  head "https://github.com/todbot/blink1-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7765cbc8005fcdeca2233f470b533288c1d2f1bc42a5e0984d3977c4200044d7"
    sha256 cellar: :any,                 arm64_sequoia: "a7b8fb971914d64917d6fb275e488341c25e3e7e2fe2bd8e160625cb09511420"
    sha256 cellar: :any,                 arm64_sonoma:  "da5c570fe69cf4a065b5931f9b2e779221ee1e4377fd2cba57ab95ec91c112f1"
    sha256 cellar: :any,                 sonoma:        "43ff210f734a4b7b33b392dde61e307dcc22e5abc3a4420fd7b2c1297ef5fbb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a76cf8c85bd885caba55246ef3fa7b995f8b0c9e3667763a049b05bd3531dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6858a243ce294d2dce4316156adca622f1b298bb065fe423ba0ba0ed07a7a4d"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd"
  end

  def install
    mkdir_p [bin, include, lib/"pkgconfig"]
    system "make"
    system "make", "install", "install-dev", "PREFIX=#{prefix}"
  end

  test do
    system bin/"blink1-tool", "--version"
  end
end
