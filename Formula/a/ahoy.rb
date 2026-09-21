class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.github.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "ed4d3b48784668dc48b81243125dbdeabecaab784b5e1c20f1608cacf83dc4ce"
  license "MIT"
  head "https://github.com/ahoy-cli/ahoy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfec4320a87043cb68e06c916110ae8d5da264259cf6c9f950c8afb0e1790644"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cfec4320a87043cb68e06c916110ae8d5da264259cf6c9f950c8afb0e1790644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfec4320a87043cb68e06c916110ae8d5da264259cf6c9f950c8afb0e1790644"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "cfec4320a87043cb68e06c916110ae8d5da264259cf6c9f950c8afb0e1790644"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "74e509a00183d99a75a3495a7d18497bf6d8c8781d8e15c599bc33f6ec91e512"
    sha256 cellar: :any,                 x86_64_linux:      "2be13b1292133e38d8d21ab8f29484399bb1ebcf61145ea23d17b9f5e3cad862"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}-homebrew")
  end

  test do
    (testpath/".ahoy.yml").write <<~YAML
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    YAML
    assert_equal "Hello Homebrew!\n", shell_output("#{bin}/ahoy hello")

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
