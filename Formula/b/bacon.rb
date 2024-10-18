class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "f078f2326da81cab31a3196d4ac43d0771d5679c7d5b32ce38309ff89f80559a"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "becdcc1bd46a4ea04d4d33e1904aa7c6a07c766319f69db0115804ba01a85afe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c0fcbc6a32bb5b6f8356e027d3bc8990c5514617a70dba7315eeaf8af2d354e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a8c0b53a24876c0615ba12dd4bef852c087518c73371b9444f54de5fbf4b212"
    sha256 cellar: :any_skip_relocation, sonoma:        "adfe40bb65a0ac6a9645e8c09b4003ed835f57b5547524436fc8d1c8e63eeb53"
    sha256 cellar: :any_skip_relocation, ventura:       "67a75ddd7f53bbbc9177c6896430bb4dfdfbae790a0ea24ef9ce1946a68bfa23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b65fbe7f9afd9b479c87441894a72508d4d84e040805a60dae3c5b0735c53c"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
