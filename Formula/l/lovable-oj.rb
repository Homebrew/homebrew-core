class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "3c91a2e1103567e03ac3d8f3926e7b15b3e7858a883296f805e2b8182cc6750b"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88f3e1e9aed59455442610cf417a0d20bb69e1e899d370c8159f4f549ea79d27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9478021216ec518dd494a2003ea1e0ce81fbdb28d834989c870918433f7c11ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92541712d69a689d270ef4a8000f96c414a72597c626a7cfa0d2ab4052d94fdb"
    sha256 cellar: :any,                 arm64_linux:       "2117b3e5d76f48c2d63cc034c0911f569cdb39b43eeae0d032f4e47d4f1edbe3"
    sha256 cellar: :any,                 x86_64_linux:      "ab3cd31a84dc93ac8d282f9fe497f20925aea468ba2299aca71eec952e7a266a"
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
