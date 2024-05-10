class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "6130d7394feb50d8c590119a640bfbba25252abf949c9630861379a58da94e2f"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e15fd38c89cad3e8f4d0decd4b7e78007fd1c7af249abf64d13699cccdcf4b3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54490495f1809467a67ab8a961370c1c2ed123bdc134edf208e56cf008deaeb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a050de6567f511e35fae812324c183b53f50794afd6d7690d7e478691b4a6bb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "faa999e950709fbcb98a43f165a6fe5edc9a8215c8bea47365b05bd9fb9ee9db"
    sha256 cellar: :any_skip_relocation, ventura:        "2c6eceaa665e5228f89a8ad57c4542d054c08b6c19de95992ff14b6756851581"
    sha256 cellar: :any_skip_relocation, monterey:       "f6b919c499f7b532e66f15208cb46fe5a60764ca6f24f9bc6c536a7982052356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a5c975bf16bf5fd774cd0f12bab96bb7fc7d1379d2168c5068c6aef9c9f62dd"
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
