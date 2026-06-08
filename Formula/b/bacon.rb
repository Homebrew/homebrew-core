class Bacon < Formula
  desc "Background rust code check"
  homepage "https://dystroy.org/bacon/"
  url "https://github.com/Canop/bacon/archive/refs/tags/v3.23.0.tar.gz"
  sha256 "5fa3d5f41c7bd7edd32859187690239108b4a2bd2e0a96037dd9e6fa00e32ab6"
  license "AGPL-3.0-or-later"
  head "https://github.com/Canop/bacon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa57501ec30180992e07650b27a67337857b98d5d48438bfe95631283b107665"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40504bf8c24461db336abf9f6265fca0456057774f41e7b8c2512f8c2fc1cf84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dd59254a92978ae1fb8fcb707db771098643c8350005e2561fa7baef1a94235"
    sha256 cellar: :any_skip_relocation, sonoma:        "12913d27e0e705744fceb834a9f5924e9fa806f84af512a2f6b5a3a1824791fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3182cc6cecb1009592ba345f35af7b05fc9571e511b11c104328323fd9af2158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4fd59cdfe6c39642187042f8c80884ccfb853fb3e2d9956fc1ba8a2c0c6a123"
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
