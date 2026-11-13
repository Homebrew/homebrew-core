class LovableOj < Formula
  desc "Experimental next generation frontend tooling"
  homepage "https://github.com/lovablelabs/oj"
  url "https://github.com/lovablelabs/oj/archive/refs/tags/v0.4.13.tar.gz"
  sha256 "4acf1d1feff9477251e5d0510f46c015398eb87831a951632e1f05608de64695"
  license "MIT"
  head "https://github.com/lovablelabs/oj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ecf5c3dbc88ae5e56eb7e5db1358faebe77f015a5c00897534d61f0aed5a28a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c59e410acbf3683893db38eeda6fe630c8ccca5620a9ad8e59a2b07363de585"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1a34f90fb8a56fcc817e579e1a7d34b064d6f7c8c7fd719909b37b71312b225"
    sha256 cellar: :any,                 arm64_linux:       "5193a0c4d790bc9fd3266b69a1e393e418552fa9136e67eeea4e72391b0afea0"
    sha256 cellar: :any,                 x86_64_linux:      "f17923651a07620f59e5a6094c8d660771ea4850d836f75942a8a7e0ccd5af48"
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
