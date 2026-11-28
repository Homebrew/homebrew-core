class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.25.tar.gz"
  sha256 "98b3cd4d4b6e7fc207286d1d0b6ef9cd14f70c996cfa5a94d57f62a27fe135c0"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    manifest_sha256 "eb9218d80af87240d519e2322491c14b675562d79f976a288dbf5929a2a75da3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c126e480f52e1f83573a4731f5a9987086e728ed8b83114935a0cc7f34f8534f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "981c1d4baa4d6afe42ce4ff86c6f13f1ebaec55a5f1e3eef5e19d7114ff66573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85cec28ff1601e96cedc410435dae1edc237d23496362936b73b3c0178b62aee"
    sha256 cellar: :any,                 arm64_linux:       "bc1c855d7ad6b20b31c83aca48a1bea763a93e60155b325ad7b859fdc5c01e88"
    sha256 cellar: :any,                 x86_64_linux:      "cd9f051ec95df87c548d6ba940d2652e9019c54350c0bf4e4e700d13ed756328"
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
