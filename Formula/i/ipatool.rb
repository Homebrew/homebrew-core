class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "36c589ad88cea989b3a5bc3cd35223e12907c609789802b59d3cfb07596a07e7"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ad348cdaaaa987f5e3865ebe510a871f9436daaadb20ff0466909dc1a1f9fcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd6e052558cd4fcd1f14acdc0c6f8cc439804ce49c0c10fa533fcb7176b8e3f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f88e49bc09a1a88b30e740a7ae32a7dacc5e1e9d13a964d086b59dbaccae0dc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "02cfbd05935f66f7410be475ebd6172c70aaa129b98f555477dd2d13e1adbd3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6576f22a1a1c0ab725ca2dd65c9dc0cffb264b2b67a7fce2e5acc5866567a027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "880c488679fcb1d9e0ca4bc6cb4105c4c74c468eb2c8ec8d50fbba6153c9ccac"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
