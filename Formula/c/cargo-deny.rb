class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.1.tar.gz"
  sha256 "0579a6469688360d0bfc1245c3455335b0c2f8ae6c40645fcf0e8e1a700eb7f6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81ac33b5903ce5dae20066ae5a4865ec5a8caba50492798ecfb3e6906f3d2337"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b731c610d73e73e974c57204422d23da817c0c9dcb2360f121ade26e96275447"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "819c34226b9524138c47f3938f572189ba4e839001b309f5bf01324f93751074"
    sha256 cellar: :any_skip_relocation, ventura:        "d2cbfa46ef6b33567e646059c3ff6ba3411d9782ab8448ebe6859e4df90ec0bc"
    sha256 cellar: :any_skip_relocation, monterey:       "cd27b1c607c4426c94970de6b970afe4046202d2ec62d44de15050b93448a362"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7edc5b2810ce70d2b24321d1429630a8ab01a2b819e486e09f1378f078923f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d756524a9d4cee78382e0b9b3958e6e15316594f694604783bc04694d3117a86"
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
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

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
