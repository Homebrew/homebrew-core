class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://github.com/mitsuhiko/minijinja/archive/refs/tags/3.0.1.tar.gz"
  sha256 "447573b2380cb5631cf2bb09091e5b1abaac4f0a2fa79551a9712b1c6b5e7700"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06b09b22c841cfe1950f43d4e887bb68097a77521b66080c9ad8bf4d9421abd0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cdc99ee5ffe4f8fb1bc8e8092b8a22ce1e1052d7d2d49c3f6d6498120ae87ccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdb643dcda937738bcad45bd59492795a195e85765cdc82bcd8fcc68b270e7ef"
    sha256 cellar: :any,                 arm64_linux:       "1a053b382c71abf3a53b6a3755192199e01161fe038a4fa07220d29c758ba944"
    sha256 cellar: :any,                 x86_64_linux:      "63e6f1a9457ac86afb314f6342d91ce703344c82db953d5db2107885cda627a8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
