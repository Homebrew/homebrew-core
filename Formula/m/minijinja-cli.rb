class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.6.0.tar.gz"
  sha256 "c1eb888635a550b886089a8b92753537533e84216c1324a644ae6149a4c1e7b7"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eb5e97ebadca7bedb7e3160533cf252e06b7d5df7be2cd5cc916c73ce6a6a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59115ec81f78c5972a87bb61f1583d8ae4715776bd3dedd977fd1e0809b47537"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e25f6a8bfd2bbe9681437eff1e54b0cbe085bd05f61b3f6a714b89ef9c3c4090"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d7076bf2fcb4d71db86c56a776e098caefe996669e81b88fabbc48cc3391812"
    sha256 cellar: :any_skip_relocation, ventura:       "b72ed6db6b822c4c98139b111e7c989f8b4da7c9722be8bf729dd4a6bd6ebcca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b1480803991e1e3c6eabdabc7791c88d3391d132e5112125669901ff634f8b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end
