class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.15.tar.gz"
  sha256 "122b30bb392869126a53df7bc57e42f93f62bc631dbefbdaddad1bbc4b36c2f1"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a1409e118f27c51d38f9f7a187dfba71d57949c802dee300f0d2fba7c6d507e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82998825471584d121d41045d33ad1b799db724057055fec9144de16df320d82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f343bc2d4ebf0404c0202bb7f34ab93e9543596e2a14ff0985fdd91bdb98fb9d"
    sha256 cellar: :any,                 arm64_linux:       "1fb18544cc5f9d375e525677639df9f4e072033a361d754653207a7dc8da79ea"
    sha256 cellar: :any,                 x86_64_linux:      "0963ae3c0b3fd4b27dc61c1970c762c89e7dee053051f65bd6b0d749c75280d0"
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
