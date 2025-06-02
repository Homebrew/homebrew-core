class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d0db0a0a4bf1fd2a734daeacc5153f82e2c098f8d930d86e733f69a517f7fccc"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc6546f3ad5abbdc7fcdb7575e0ea38f1f8f8470a8af27df2a0c0dcb4b8dae96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3901c427da5768f9fcfc0f5baaf07bf259c3e1ef5a2ca3509cea75a42a3215f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0af3a4ce7f279a7bb7c9b0d1115af21d8a62d9035f60b735c97e07d419614df"
    sha256 cellar: :any_skip_relocation, sonoma:        "7071659386a76a300e6b976b04361de59bc58063ec1b814e3f8f0cdf65370b7c"
    sha256 cellar: :any_skip_relocation, ventura:       "a62968d3c06f4fda5e3adac28bc6c453d4951faa299bfcaf527d406772344fa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d3e529ff010e41115e64caa5f79497ce0e7c054074b8f4a60077faac1b1a596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9eb77fb91ba79cb97efd54a6192fdb6617d610d00cc78486ba239e9b6b200f49"
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
          bear
      OUTPUT
    end
  end
end
