class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "ef00bd7887647e6cc1b4cd105cac22cff4165d51bf9ca684796bc2cedf740a3c"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    manifest_sha256 "454bf1bec861d3fde05039086afda05932b22300617e41592b152a9f9f112a1c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15717c88d7721ba9a37b6d01a4e5bf05a24b96004a0603ff10e1d9b63243a1af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "40b60f05f61bddf153d34d600ee22b3c443bc6829d394252dd442035f0cbfa6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11bf6f97fa37dc9b5fe9b25dfd5ad92da94aad6e5de5682ba692623bc9cb0779"
    sha256 cellar: :any,                 arm64_linux:       "0781ff8a3ad9d535d6c5e6f9b1ffbf963c5060a55318cf372125d03750022cba"
    sha256 cellar: :any,                 x86_64_linux:      "0dcb4217725a7488d2c8b96dac253e4e8ff581d2a9458efb1f98aded1b9c8c1a"
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
