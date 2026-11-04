class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "f6ae61edf31035839a08739db89d54b8c401aed5fa5ba0da668aae02dd00e254"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59568da7ef030a4c4fd481a45fb3fbdb3dcf78c07bbe18019ef031a80b455a77"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a37c97e6deaa2095dd184d64dbf4b60839a9ceec37831d2482b234bc436b4eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6c0fa613468c0ecef4cd4ea72e1d0695587aba984b0f56eb630c8adb13557f5"
    sha256 cellar: :any,                 arm64_linux:       "b135159cab57b7e8f89f0433bc95b33b30c788997281f4b53deb28b707f4e0bb"
    sha256 cellar: :any,                 x86_64_linux:      "00463bcf59dbdecae736bb51ec4187f562149a15e7cf741900a59868c9cb8b72"
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
