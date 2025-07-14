class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.11.0.tar.gz"
  sha256 "08f9f73be493b0b1ebc6e8e69e38594e6531d99e416b0cbffe4169852443552b"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ab78aadfe6252716e98e034fd96adffef69f69adb30516ab9485bd43d5795ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "476c7b53e8c9233839bd724e90454d9da8a574e70ceaaa3d2fb29354d4e2965b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49f92d327b2204aa4233497275700f578580150c327f2796b4e7e08383f40fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "12535acf236f149caffa953f8b84a9f2a3a8e1a2659ae81876173100854e5bf0"
    sha256 cellar: :any_skip_relocation, ventura:       "c1260828d58d4128cee7f23554d8820de097e21bde36b47545857c1d1cb9d134"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea5aef45dbae8acc87bee303756fe5cb74d7f187c8428b27a781e2a95c9512a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4991a4bb6df0974a6d699f57b76adcf985d1a0c0823eaf5a1a181031f5da5614"
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
