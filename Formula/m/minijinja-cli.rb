class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.21.0.tar.gz"
  sha256 "4a0fee7c711484f224349669ddaaf8a9d2a98a9c4372f43e999df3069c8b45f8"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5863c409d211fd389550adcf1f470dad97485934a22fb8a953b0101583536db9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1e38bd7a4bab2f9def30e59972b721ac30f61ee7dec8f03f4625a14c31951bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23e89bc1fa42601001caa0c3def1dc5427a6671c64bd20dbf05c45701583112b"
    sha256 cellar: :any_skip_relocation, sonoma:        "881ae36921aa5a43147ac6803f1a3a2ebd664e5f48a4019bed481d8e5aceeb51"
    sha256 cellar: :any,                 arm64_linux:   "ae7d381dbc29594c96ecaca85afde80f0f34706da73a8e4e7f462bd17fe5d4d4"
    sha256 cellar: :any,                 x86_64_linux:  "4511ed5bfd0331e42fde587e618dd8855262bc20f6d11261e2fbd6caa29f0b38"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~JINJA
      Hello {{ name }}
    JINJA

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end
