class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "739974980e99c984b7ef58e95e8339f601e83f0bf07d6cb52411808251a29201"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aee8b03141f32b3ec0b77171b1ba43bf33080c13f579f446546a37d616df4271"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e969d20f6903bdd1aa8ae5478b1e116c372364ea8c8a71c79078c35039b319b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "984255aaf96f243d9630c28c7f8889808257e3f1f792cccf414d31aba20baa58"
    sha256 cellar: :any,                 arm64_linux:       "c27edcba7e4bb12bc10b4a77dbca4a68a14d40c5ad21b26704ad9949341b1c93"
    sha256 cellar: :any,                 x86_64_linux:      "3783961d16069e41c241a7d0d1e6fa347a5a363c244f5e48605cee843ae18ab8"
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
