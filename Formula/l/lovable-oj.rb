class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.24.tar.gz"
  sha256 "4a8daa342584c6ee6e5a5a1ad84e8d09e89799c4a89013ccf74ccb671354531e"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    manifest_sha256 "4ee251db4ff7d30e37a91adddc128d3f8b6ce42c1e608659d13a9d929812e79b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "581b21340632936063697d92aa53b8201d8c23cf3069508ecc2e631d95f26c07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe45ecf4133ade175ec584920dc66185b42c29e6511605e9568c92602e4c732d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9961460fa3b9f8e6b8f792c53702b2171364a0e50f8033c9de4564b132f03aa"
    sha256 cellar: :any,                 arm64_linux:       "5191812d7dd40875a0acbe5b9f2294719c38a32f1d825089abbf5b96a86b1e8f"
    sha256 cellar: :any,                 x86_64_linux:      "ded4ed29da35d8529e1af7e1ee7260807132a17efbb2f73d9d3ef23f9f5d4599"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `v8` crate downloads binaries at build-time
  allow_network_access! :build

  def install
    # Work around SIGKILL on arm64 linux runner from fat LTO
    github_arm64_linux = OS.linux? && Hardware::CPU.arm? &&
                         ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                         ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "thin" if github_arm64_linux
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "crates/oj")
  end

  test do
    (testpath/"index.html").write <<~HTML
      <!doctype html>
      <div id="app"></div>
      <script type="module" src="/src/main.js"></script>
    HTML
    (testpath/"src/main.js").write <<~JS
      document.getElementById("app").textContent = "hello " + "oj";
    JS

    assert_match version.to_s, shell_output("#{bin}/oj --version")
    system bin/"oj", "build"
    assert_match "hello oj", (testpath/"dist/assets").glob("*.js").map(&:read).join
  end
end
