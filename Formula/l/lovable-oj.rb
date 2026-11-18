class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.17.tar.gz"
  sha256 "9c55ff5a37e5420824823bbdc8fa628204b7f32a4f2757839bb55f8eda81dc9b"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e092eeae2cc62a8afcc7999f92798e69af6d05abf0aa938c753d9c3931ae109f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6e57dc310227687dede016262dfc8e7c4de7530a9b405983d120cdabc2062c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a95f4559773edb80a05d652535600bcfe1e8e7714a87ad6a96f9c2bf96b7b4b3"
    sha256 cellar: :any,                 arm64_linux:       "6546f422c2f16d2e62d4bccbe7a02e49da5c72c0576af434dea144a7b411880e"
    sha256 cellar: :any,                 x86_64_linux:      "966dfccdb76caa6dc131281bfb5095bc9b49fb3c7eee6dd9351c24cc1ae2b585"
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
