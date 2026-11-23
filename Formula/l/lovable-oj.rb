class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "ef00bd7887647e6cc1b4cd105cac22cff4165d51bf9ca684796bc2cedf740a3c"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    manifest_sha256 "83702f7847e8b7de7df9ebfe98b78595b67873237bb73bb9ef0796b82854205c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9e9c8284794cff18770c82ae9b035abb6d0fedae0742510cb17895294357cd0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "99f749a9973a7e5475f3d1cd4ee68b809fc977fe49a9dbfcc794f23e68184669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db88e044b3f9471fe901be67d36efe2673fd6cbc0bb84a25de262d52dd941b78"
    sha256 cellar: :any,                 arm64_linux:       "7141d419933d0efa0f3912f2c204d852182c26259e2f8fc7e88a7a29d1519441"
    sha256 cellar: :any,                 x86_64_linux:      "ea9ba17e1387fb0b9bbae0734d5b636604207fe4c2d1ded49f4f4ba3e144cf42"
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
