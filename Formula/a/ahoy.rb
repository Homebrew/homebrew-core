class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.github.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3c9758dd49f635af85530a7763248e2f4532757fec0680ae6047d44fa518a45c"
  license "MIT"
  head "https://github.com/ahoy-cli/ahoy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e747fab44f8905986a9329709b87c5144014246f339dde96ad14de7be03cff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e747fab44f8905986a9329709b87c5144014246f339dde96ad14de7be03cff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e747fab44f8905986a9329709b87c5144014246f339dde96ad14de7be03cff1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3255c51a166d6fe8fb632c05b371a3391d39b6b279f02b5354594d87093582f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9a4a1611d9d9b07436c63c097c5b0b88d9ebbafa5e28c262dcfdca0681bded5"
    sha256 cellar: :any,                 x86_64_linux:  "5bcc3962b88cd65927a229246c93c727f7a07e7fce2d9e7f98f066916115acdd"
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
