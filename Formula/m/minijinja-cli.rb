class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.9.0.tar.gz"
  sha256 "22efb07f6129d78752b75c80a0dcd938bc1a59fbe53ab573c3591b12dceb77cf"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bfc430da95444a4c58d6d750d847aa725871aec4808a19f7bbc42a0f85e486d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f81d2fd0aada13a072ffb500401d593c4204a2cba0b50a792f98b2fdf72fdb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9c5b2d6874712b74cd70c3cf0dc79b2d29ec13caf87137e127385a6813bbe21"
    sha256 cellar: :any_skip_relocation, sonoma:        "b43d6c1adcde6b09fe3f392fdd747aed013c96a909a8489717e7f142608b5f16"
    sha256 cellar: :any_skip_relocation, ventura:       "de9a85db0446258b569a3093f06299e9e3e9e19e526faee1130018660a6c0fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16947c69870c78b40a335fbff58ee44b9fb56fbdb150c64cdc2ba5caf4b293d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eef032518284f3965084df205e8bf55b5abff0f135b17727b659075e0ff059a5"
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
