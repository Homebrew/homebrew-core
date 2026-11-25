class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.23.tar.gz"
  sha256 "c340fb70036c638c4be793ac45deefe468adf7d87c44511ee566df419edbf884"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    manifest_sha256 "e4416f63fc17b1573e174c0359fd8d9d907e33b23b8d0dbb1ab04edf422dad34"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "da0bf57fcff4da2e644ed14578e29d7adfb4aa1839314887148ea4a1e6a80187"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2d4f52095336dc7bea4462060766fec8a5161232fca8a4e472d13287dd0167b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e925afb2637d20743a8edee2d73fde2a9c0dc71ba10905b288f9b70bbe933be"
    sha256 cellar: :any,                 arm64_linux:       "47163df064daf6b0b009d8d3cab67eacbdcf107b8e43e99d3f4dbe58671307f1"
    sha256 cellar: :any,                 x86_64_linux:      "a560743abd07f25f0b371d1d52dd63825e02e24d4a45649197221e0346fdafd2"
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
