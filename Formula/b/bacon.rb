class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "c8b6cf52918a1fb42e7f725fa4215145ebeea22c4edb7c9a2050972269856f19"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cda49ee3c757960a56d4a2b2c4e9b16487d0c6f54b056879c13828886467edf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c68c68bbce8b72b7ca75eaea1540c1b9e7027b7d59c79c9af6eb0824ee868724"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c81ca2f7292db44ff87e058994bd25d4ff6ce2c738961e7aec8f2258e7e2d733"
    sha256 cellar: :any_skip_relocation, sonoma:         "021d02e2394ab84ebdf97345844cd78f5fe5a03b3a611c6456aca0d50a2f5ea0"
    sha256 cellar: :any_skip_relocation, ventura:        "24025bc0354c90b95fb938d1b9d689b68cd3d8d73902aa61eed1e956e114687f"
    sha256 cellar: :any_skip_relocation, monterey:       "f303e6638e6a68d3795069904ae55940c0367a244d3f741a10d34fad839f0ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d2f01c1e6565db9803c87eaf1b309a241cea7a27ad1e7fc1cbcccb91562452"
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
