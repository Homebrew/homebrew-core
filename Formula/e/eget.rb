class Eget < Formula
  desc "Easily install prebuilt binaries from GitHub"
  homepage "https://github.com/zyedidia/eget"
  url "https://github.com/zyedidia/eget/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "1d36e2e77caa5654c01efb890993f489fc6ae3b5b7f3e6fb0159fe946d6e7a06"
  license "MIT"
  head "https://github.com/zyedidia/eget.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "580f539b51e54202329b7774c77c0561314dacd6cd27289ce27db45c43b27795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7792046d5f98175c044e8ad372d5668fdc8dee721bd6009e3823e02c2d193086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3279e7e0353f0298b42f5b041b7aee988b714bea17f28811f83696e71e2bd55f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8005b8b5701eb72e3f8bd1a98fc79b533ed9400162b1d78b9714069c9ff5c235"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5ffde8dc91bcd3d11b90b93bb32d115af36df948b2c380cb5b0422dfa05e537"
    sha256 cellar: :any_skip_relocation, sonoma:         "eea1964d92f3d5fa7873604b3e19b0c01795e7c8540b842baef8c10ad5ebe20f"
    sha256 cellar: :any_skip_relocation, ventura:        "59ffb0c7a037e94eece3ef3a5b2c74d49644adea9eaaafeb1907fa7885ba671c"
    sha256 cellar: :any_skip_relocation, monterey:       "41b43a146547e10c0b6ad089441689d5eddf809e368e10bc79fb732146dbbd7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5f163bd876079a21f57ff6dcc1c5ba91a5421d64f5c217eb16417690c7452652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a911326f33d7cd8d070d16b7f3bbd5de0327fb2919594efc8d218bb6f8fb6b"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    system "make", "eget.1"
    man1.install "eget.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eget -v")

    # Use eget to install a v1.1.0 release of itself,
    # and verify that the installed binary is functional.
    system bin/"eget", "zyedidia/eget",
                       "--tag", "v1.1.0",
                       "--to", testpath,
                       "--file", "eget"
    assert_match "eget version 1.1.0", shell_output("./eget -v")
  end
end
