class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "0aedb72441ec3c2aa41344051b3f1c9fca66156fe696ab6957ff275bccf3b233"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d3ed952e1054848e522b46545b3b7795793c2a88cd0d3f7fd01fcbe72d312324"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1db4747ab33ece56ed033f92f45ee235046632d5cbe1a743b27049348914400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52b45216ebd99aeda208e68178610353dbb315a9938f0b607d399b1c79e559bc"
    sha256 cellar: :any,                 arm64_linux:       "55e5273f80b24b2f113c165f1893f5fd4311a92236ced3869f44a47729668435"
    sha256 cellar: :any,                 x86_64_linux:      "ba88507c210872b0a15143e3e66858f6b69d55f4380e1ea3e25d4ee1f5e7f108"
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
