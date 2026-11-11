class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "89072fd39e8763a43ce9ede1a8615f53eed6e44c1dc470765a4b0a92a3f19b2b"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e600d29058702a9119989a695cbe28e836c77e911d2f27807022458acf5c4c4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5135df38e336f56f58c24a5ef29a7932589321e6fce525ce528e74ac18c2b6e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57366affee89b02ed9ca00824e24df0dec2ccf58c829b0fe8eed83066d16b18a"
    sha256 cellar: :any,                 arm64_linux:       "d59963cd724fc0bd2558f463066d545de699ec8d198d3795bb8f4d1c33769b7b"
    sha256 cellar: :any,                 x86_64_linux:      "53ea1fe5e065af094ec2200a7d5fc7e81a34356938576a5f7f6d19c91eca05b3"
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
