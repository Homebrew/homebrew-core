class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.14.tar.gz"
  sha256 "71969c999afefb99922073ddbec3448aaacd9319658f2baf2380d2e378e4c799"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d5b8825eb54ce6c442b533de2a4ba4049aab6a5ffe770a2fb7de014e393bee9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "120074ddabb1365d3ed0a4342672a35a98fec665e92982cbf9b50e1e6159b1fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f28db68f27d8dc629da6ffdb5854e78fe36f27d3ab85aaa1e69188f5eaaae9ee"
    sha256 cellar: :any,                 arm64_linux:       "7965c9492668d86c245475128af2c6d775fb353f56d910a4e32abdcfbda85d3a"
    sha256 cellar: :any,                 x86_64_linux:      "9213191c7c37e08755b08e5e152ece39ff97b6d30e4cc3170ab7eefc3c0c6709"
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
