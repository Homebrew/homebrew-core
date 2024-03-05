class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "358e8168e5cbcb4748166b1cd38060bcdc0da7973289b5cc8f936425b89e46d4"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0c75b3f2fb8fa169d2f46b46d5652c44222a8dac49b5306ed609888e1fe1bdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b424838227560ae98bb61cdc36f24a9a3645722112871e36f73166396fe036b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b307794af296cfa2d0cdc603935f85400a3a048aa395a5c62884ad14dfae67f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e82f6b2e4897a30a530ec80e2fdb431eb5692cfaf19d6410985db63c4cafc025"
    sha256 cellar: :any_skip_relocation, ventura:        "325f35f62b453d26a92e504125c8708da7233b6a16e607f3848f3885547d13a3"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9cf1c46abf6aef768583c6e114acd98b7e8368fc869278f9092806cc000907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3a8a24cad3581f9f32f61b301ba69a52eccb541cae2abc2c641c7e6233fad19"
  end

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
        license = "MIT"
      EOS

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
