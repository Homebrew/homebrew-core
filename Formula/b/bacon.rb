class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "f4efff4960f7bb80a33cd6bf3f4d8c9c90c73655e477b43ced058fd0b3df1cab"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76b1b44f1592fe0343a6897a73b69c38231da84e696d022f6de63e740f86d603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a8a8e2cd79120198ce3d10c6d1fd71a5e48598b4de4501c85dcd31960896bc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08cebf3da70729e13a4901c4ac3a37234fcbed0dc6ee87bd195e85eed7c33e57"
    sha256 cellar: :any_skip_relocation, sonoma:        "dca403fb5cbfa032021b51abe83dd11501c883f468a61e47f069df34f201e274"
    sha256 cellar: :any,                 arm64_linux:   "9631b3d97aa76b6c576f59b3960ff5e1c1709f079f97e34ad412971c44e4c74e"
    sha256 cellar: :any,                 x86_64_linux:  "a08905ddae763f530a709357cad0ba9ed1c0355f215a301358640d9ae5129438"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      TOML

      system bin/"bacon", "--init"
      assert_match "[jobs.check]", (crate/"bacon.toml").read
    end

    output = shell_output("#{bin}/bacon --version")
    assert_match version.to_s, output
  end
end
