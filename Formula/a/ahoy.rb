class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://ahoy-cli.github.io/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "28a4a005126c797411b269fd873cb9c8c3a15eb47cdc63608be0d904fb9c4f23"
  license "MIT"
  head "https://github.com/ahoy-cli/ahoy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8b6fca45fdd1b82131871ecfa6e04945d56e199cf1ac9ae9731fed551105b81"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8b6fca45fdd1b82131871ecfa6e04945d56e199cf1ac9ae9731fed551105b81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8b6fca45fdd1b82131871ecfa6e04945d56e199cf1ac9ae9731fed551105b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a1069158e83e29bcec1e8aa2d08c891bd1d3b338e25cf83e5bd9a107bcc4739a"
    sha256 cellar: :any,                 x86_64_linux:      "8f4e4a978352ee3a30e277a08b1dcd3a57cad76f7dab7e61c0b67dcefa926782"
  end

  depends_on "go" => :build

  deny_network_access!

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
