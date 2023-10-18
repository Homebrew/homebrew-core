class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.3.tar.gz"
  sha256 "7de9e0e55f353a7396ca2d93645ec11ce14675749752c938fe2f63b68dc84e48"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91d5661fc938bb7894a0aa3db2bdc69db917cd83164527a24ca34040f6c8017a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cdfae471d68e221b3aca50e6de62829b78925fd0d78bfdfae4329157645b52e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99304d7fbf7a78f35ee76b07e2abfb702931fc739f37ac94349c0a02329604c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f92a68101c54427b96f2c4a0077267899a31744c39a53f5e03a518a702f8b54"
    sha256 cellar: :any_skip_relocation, ventura:        "bf0ca42365a4d6d12281321d59800ca2730a1a83c246815b66d3a80aee8e5a13"
    sha256 cellar: :any_skip_relocation, monterey:       "d79e86b311472b0445afe15c5b5451955426e47a8869d9b03b7a2bed567f3fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a8aef0c5084e7afd055639cb0f7d04158939e6227bac130fdd0e7f484bb5477"
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
