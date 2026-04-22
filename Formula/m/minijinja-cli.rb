class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.19.0.tar.gz"
  sha256 "054381f65bdccea2f778872ba78052b174bdc70bad69cef05fb5ced0eaaad89c"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e1ae783527333a6ea50ac164f4574c70961b26cd16e1445a24bd32e8cc5247a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c946cb4780acccda155c2cbe5aac0c07620d4aaa0066d18cabbe2026b1dbd01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26221672fe0e78addf5fdae9623ce89318c291e6308be9e7962b567e7baded61"
    sha256 cellar: :any_skip_relocation, sonoma:        "24702b5c73afabea977a9160b36b9163de2d57cb9e9f5c9d6dd14cc62ab35637"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e09936a693fc22888c30ce1fe811e4636afaecdbd2faf52339ac2952b9110c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3606d0cb650022d3b3a5723531b1878679e3fceea3f12ac557e457d6f6d3ce8c"
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
