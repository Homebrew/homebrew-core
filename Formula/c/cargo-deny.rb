class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.11.tar.gz"
  sha256 "c7393f6ac05ffe78668c54f74a99220efaa100fcd23cb569834d356a3f33e165"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c95bdd87ce6138ef6ecf896adb05313f3dc6e8c12f6e8517765e0855afd7dffe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11c92b48603119b53ebf0bb3c79a1afb40b9d6a7483568c271763decaf4055ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c57e99b26525b0085223e1072c1b495192a0233dac35878c30e49ec0c3ae9aef"
    sha256 cellar: :any_skip_relocation, sonoma:         "e72776e75398cb97c4e7ee1ecafbbe1ae213a9efee55fa024d93e8fde82ebae9"
    sha256 cellar: :any_skip_relocation, ventura:        "ac684b5fb4c4a57070bc7e99c635f275ab3bdbb1f8b9019952e460aea2b75d36"
    sha256 cellar: :any_skip_relocation, monterey:       "f8a46e5535f19d5e9636d4159ff73c11cd06309ec1fe92034973db6010bbc12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c979d30a2e8db87f0d8460ea69923270f07b4fd64573b6dffd0d7f02d4f7a2e"
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
