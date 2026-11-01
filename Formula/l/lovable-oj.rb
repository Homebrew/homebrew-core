class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ed6c4be70a5a87fac5f1e041c5845bd33e919e66260aef4765980431c5f1d2e7"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71960f771da3b1d598baa3ce82e1d01b5005428d5a86575a505e6f1c08284e68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4857a09e0f7324752a3d0f595604f1ea983f251eb94ea6a5b13cc90799dcdd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3a2b9543dc1504bbbc8604264ed74234802a8a28be52d21567eac8de1b0bf60"
    sha256 cellar: :any,                 arm64_linux:       "141ca00da77554e9020047efb082773fc1db777ceb358a2e25bcd0b28bed7dff"
    sha256 cellar: :any,                 x86_64_linux:      "274b6ff5b89f4a30a31ad3ae5c89a6251b8e3e293cf06fd6cab997f406d44a50"
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
