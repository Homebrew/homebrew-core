class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "612113c2b43f26b5b72262d4c964a98c153562cb7cbb27204900c9c72fbc0bdd"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86243a5622f42e605edcdcab86044bcd75ea920dc5e393bf7b20ff6032f9a4b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3694e7ab83855e798c38fd7528cdc564b3219582755b6836b3d0adf6e672901b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63fc357eb8c947cb33589da1a7a0780a0d8566c23fcc7b3176014402dfbb22e2"
    sha256 cellar: :any_skip_relocation, ventura:        "6d565a1b96e0f9b154adcc0da5856a45c143e56aec12c3d5802c26c38bc48fd3"
    sha256 cellar: :any_skip_relocation, monterey:       "31c709cbafebfecd804d707740f3350d712407c1368930150638d5929157fb04"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b5ed2335c041176bfab66c4eb06d6107fb8cee0b12f0798caa54ffb9535e503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d28ff8efa4996801e8dc5fb435a27c45b93042f492b7fa0a092dad0cfc6ca0a"
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
