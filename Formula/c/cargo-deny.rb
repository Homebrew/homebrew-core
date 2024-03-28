class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.20.tar.gz"
  sha256 "94215faaa36c2a9f28c0b01ac5ee2616bd5b996b21b3f5572c6e0a2133d86997"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1eb9ce53afe43f51e06a0eff18bf19354570353bb76f8bb8f9817f561442c9e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "238446a565199e5b086480be92f1cd1a0324ae73be4b1292ba5fc672ab2101b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd72fa2505dd9efd469bcc97c60599e46d4038f056aa9016f85187260cb6ec93"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca3b8f0631e2b1fca5742e33c29cd8d348cbf682350713f6c0f093cd1a9dc6f6"
    sha256 cellar: :any_skip_relocation, ventura:        "f33fda65aff26d442df9120061b4c8d24a60de2338c0dda195a578f042c78f03"
    sha256 cellar: :any_skip_relocation, monterey:       "47e7b027ad5d68075fe32e00b3091f67d6c7f22ce16d855a1d75632ba6209747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "155e6448213268bd049f5b990bcec56825fa271bc588e5e327d10444d994b53a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
