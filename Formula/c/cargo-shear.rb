class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "338686a1d413b59d406da4ec7e336020bf62ca4cd9fb82c9b98b8f0a5ce24680"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5860025f2102a70a396323940aa0ccd9f8046a9e0fc81e2180e3aa45b383c3c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c25bb36d6cb35286c5dcb0c49cdfb8d1bf395f7d80074c57cb0a0336471f26c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f84c6ccfea3bc57b6405f3b9d8afdafc8520c670b3d05ac3a0e65869a486dc16"
    sha256 cellar: :any_skip_relocation, sonoma:        "7093d75e8020d2e82ba3db6a419a6b57b16f6c224a8b1bc07a8e39b7a7592c27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad8afdaa49248c2a3606e9da19957ed5a2553612d8c5c9406106bd74906f721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179c0592452607287ff173ad6b4296a09fc0a340c336eb93439ed78f1db5bbb7"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo shear", 1)
      # bear is unused
      assert_match <<~OUTPUT, output
        demo-crate -- Cargo.toml:
          unused dependencies:
            bear
      OUTPUT
    end
  end
end
