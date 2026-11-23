class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.20.tar.gz"
  sha256 "a26ca210cab88b0565c49af59512e0a01a504e948f004c658d91503b621e8d18"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    manifest_sha256 "1604c9e1b5dcc1c1dc81a7742c324e736b7d8b646c941cb1e025982f3e705498"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9665f81fc747947e91551b7882c32c242b9fea1190ca8523f811567c93409fb8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2fd77a3c48a425dfcf355d1302d23d54e7cbc8a4212cb37217936535f918751a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2ccadde98ad8418212370c1678cb513d8d45684a4cbc9fbc1848adb719380dc"
    sha256 cellar: :any,                 arm64_linux:       "2b618057b5aaf2f8c0eb5f8c8c535f368bbf4e5fe6e93d45d2f37eaff90f47cc"
    sha256 cellar: :any,                 x86_64_linux:      "c3c7fe80449de5fc8c4fa961886dfac0982c39f3439e5460e1727287e99f6b47"
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
