class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.23.tar.gz"
  sha256 "c340fb70036c638c4be793ac45deefe468adf7d87c44511ee566df419edbf884"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    manifest_sha256 "0d5b9000749f15146f3f3d9468892209e581fc0915abe74d8e555c51e4297f4a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32c719fc3f687077123a49407e5677f0f4781a42464f107401c81ba8673e8f59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8c08f56de31ff89144e6f82c15d520afb8bf5a659bcd9b3972faf0b3469f725"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0cedeb78ff796cfa1e9aca7e8ae53df4ee6a71b7796770f82cfcd1d5dfb43635"
    sha256 cellar: :any,                 arm64_linux:       "a2c59328f3bb01b92f48bcdb446b6c0ef80531984f9c703ed540672c90c7eee4"
    sha256 cellar: :any,                 x86_64_linux:      "92bea79dd704235d744ff11bf5271e0b02bbcfef14f502d8e16793f008ce615e"
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
