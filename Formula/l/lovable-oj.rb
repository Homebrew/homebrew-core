class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "50d61099e6367ec3f6d6818c01d004f7ed5e145c2be5ce27903242a77deb5aa7"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed1cc4aaf6c451ac1c9201df140b5d4d408fa3c2419d43c379e4d7e22ea7c334"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3603b24c77815d8100e85b68299ed3231f54856215e511cf728b5dec2431dd0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5182a9d009d345d53bb09650dfd7514e9f4f0d2dd02d112302f7469e02867d90"
    sha256 cellar: :any,                 arm64_linux:       "9ab8ab84a217ec3707d4df6d1a0eb29eda502452a4d479123d88ffef53913368"
    sha256 cellar: :any,                 x86_64_linux:      "f72ba426e63555bd6c38ef2544fdb6b61849ea7c9098900c0fbd09f4fabd0e81"
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
