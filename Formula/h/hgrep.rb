class Hgrep < Formula
  desc "Grep with human-friendly search results"
  homepage "https://github.com/rhysd/hgrep"
  url "https://github.com/rhysd/hgrep/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "66e30cad042791afea218f7a31f82ffcb7b92b57ba44c7adee1f792029d9cd86"
  license "MIT"
  head "https://github.com/rhysd/hgrep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5aa7107eba4b90c77c23b1fa3b1cbfc73cd7506bc3ff3f55cb03654fb60402b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca9b2c3054e524995f8dcabdede8ed47ad009f3a189a0f0e0c273f63a5f650ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f34f0cc58b92e9061c0591042a55455b03130214746504be509dc926197d7698"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab4157c7237348c2592358c4519644964118cd3494b0216e6738f387863554a7"
    sha256 cellar: :any_skip_relocation, ventura:       "996382e2809c829808cb9763949e5b766344121e547736230b906e883e0e2dcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7c6c0f7b280917573b6d4d14e7870cec2b8beec186524551bb9b7f40aa71779"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hgrep", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hgrep --version")
    (testpath/"test").write("Hello, world!")
    system bin/"hgrep", "Hello"
  end
end
