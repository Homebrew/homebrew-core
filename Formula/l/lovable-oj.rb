class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "d03811f75e31ad103d198e88103dfdd3fbf8923d05bc06323a5aaccd40a58eef"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ae5e2385c84d572830920fda1e9be2102d652d83be948c8006ae1d2eba1b41c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15eafd3900777c922b2837ea3d7b521bec502d54c9fdb8be122562f18634910a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d59c7eac2ac29057652dd4b9cc4616def30ea34889dff6ebd42ddfaf30acb04d"
    sha256 cellar: :any,                 arm64_linux:       "e40278f7e1a257ec964c6637a2888856bf8f1414dda4ad28256813e6519ff579"
    sha256 cellar: :any,                 x86_64_linux:      "4f2e98758b5f8afa862c5ed36984800f693dedcf4923d0d99a03f5a5c2cd3d01"
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
