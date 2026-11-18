class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "9c55ff5a37e5420824823bbdc8fa628204b7f32a4f2757839bb55f8eda81dc9b"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "53dec8f657721eed0a36321922d4bf72263ae315aec50348de1257a8b168c6c9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b67d7f85d1cbe6ac237e0328424c297d92b778ea1823e63b59032e2621dbb5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cbf204d0a74188019ab35cd765ec473df0aad0519ae3a4042163245064659412"
    sha256 cellar: :any,                 arm64_linux:       "f1c85c2111632da1399883e8633602f2c99c22bd18ffd2395561f32421ae9cc5"
    sha256 cellar: :any,                 x86_64_linux:      "701499a54d6cd2cd38938ea756457efef0210adb866949f3827186a3f4d1cd8c"
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
