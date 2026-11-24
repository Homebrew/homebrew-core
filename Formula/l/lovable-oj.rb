class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.21.tar.gz"
  sha256 "7792b494e11d348e41ed7ce2b9a8d4c4d11b7229b00afd89a265a6a41db26fbc"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    manifest_sha256 "02301e13137a23eebd51dd543431db2a8b4bab18b67e18a01dddf168fbc439db"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bba08b99e6fbbd7901472cb610e8f2703293c068389ba7602ddb0417f8fbd818"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0191f065642e657da3d419e8604a4e30f19692255713f5ed7070340c63bc0894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8aca73ce2a85707e14cbff9eb34196c93bcb111956bb5b1334a7042fa28b6746"
    sha256 cellar: :any,                 arm64_linux:       "b13c2cbdcb8aa43fe633061d7f84746522f43607910e681164cd7800a8808003"
    sha256 cellar: :any,                 x86_64_linux:      "a4464bd6393312f5bd7c1e16ec9fc0b1e8a1768c399b5234d56d0123ea74fffd"
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
