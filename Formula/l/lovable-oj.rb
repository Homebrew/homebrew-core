class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "6836bbf303fc2a719b82d0b433f64db7c7be072fa2658ee4478f249ecde1e680"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cbdd7f7674e9fa7b46a7d61905fe92214c9ff69561077648b36a5e5cb4631328"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6261485a7858dc1e65208c03625bbedefc7a94a556acca31eb973e7367c0e566"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bc4accb5006ff3956cbcc45e333f61c8caaeb469d5b6ca9d8d821ec1c3e2992"
    sha256 cellar: :any,                 arm64_linux:       "e672c0c8617b1287e3ed23ed143a0aa4aa062d0db14778787870edcca6663758"
    sha256 cellar: :any,                 x86_64_linux:      "c5c2c7c8f16c211f756a5bc800c258a1bf561442a87c087aea838e72eb45d7ee"
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
