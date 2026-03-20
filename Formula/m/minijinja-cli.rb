class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.18.0.tar.gz"
  sha256 "b9dee8ff7c666e013da4ead63c6fa13e85b742221d08c86bec70d06a0c0dc729"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4581cadb7855e70dd13783c34fd9a33d4523d18c3dc161487dd898be66b8d594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08e07f958afc495f3deda5236c736a085290e571c4d2c113a6299b27730ba83d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f313035d2807206ec42b6359120fca445287b239d4ec47b1e6087a28b66c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee340891871c69f197f2717e0457b7249f7a79c459112645b130eac70dcdbaf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45889befdccf3834d82aa17382d61a5c4c7014ca9276852a075d5ce7787aaabc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1198750dd534908b6f5492ddf87be34f19b1d33749f47875be02d922401340a3"
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
