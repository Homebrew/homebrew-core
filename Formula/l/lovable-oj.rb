class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "88f8d4c4d6fef3982b61e6fc062a8d37cd465982d9899ebabbbbfd12956c72b6"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd3096a5b90c6c89831a517e97ef64fd67db32434b76c160b41ab100ffb9686b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "effd9102bcf92cd89989ce4b367c8bab7c51f6d9c6cdeade7a7a4c2f231c1c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "128c418a7e695ebda4b0adbe2b69ab313b0f1685cdc95f758854dd36cb02b419"
    sha256 cellar: :any,                 arm64_linux:       "3b5a5a5cedb64da8dfcc3f5d2ca14a4798452f1633efe228bf4c6dd46089ac08"
    sha256 cellar: :any,                 x86_64_linux:      "7e2f69dab1df2160c00d55ca0a5a86b56da1f337df4d2bed8925f48d92a14646"
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
