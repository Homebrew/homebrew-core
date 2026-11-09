class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "7ddedf1becc33ee27fb24bd5f1d74d7194f35e5c6150777e54fb7d54c0dcd059"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3bd59151da264420482b1b0714c3fdd1d4a7e2e61bc8b3c02db4e7b71bc17360"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f38ed2a15631f9be21ad51dd795c4b888f0b735ef185d4f56e7d3b7242e255b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "594e0c2fa86ca08f337af8dd282ec2cc0cc90aec8999a075a2cae4042019274d"
    sha256 cellar: :any,                 arm64_linux:       "7c77a368949e23b6f9e223b6b48d6dd5dc77ad677c849804dd0e68d3373f600e"
    sha256 cellar: :any,                 x86_64_linux:      "2bc3afcb0574381045415ad2934ffe63e7730b96b24014003eefb6dccd7644b9"
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
