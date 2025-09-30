class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "669cb1fbb6e8b37d4bd8f9dec802e7238f2d9b58fdc8377a888f5031d5a2776c"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb0820f99645c12c3adf397315afb2014c6552650d4486797df1e3b81cf5a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d886a19c169d49f255e5064a38e51b0a45f743c2973f6c997893eb3d862d8836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16ccffb629af4c6decb51d24cf78e2d9bcb3a2cb205697834526af76bc581f2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9015cb188c7bbc5cb36d0dad2881c8559b6ecee3550db047513b09da5cf8a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72a2f45b2b058ba46e92d676b69b85c3bd06d28f27a408417ea0043e8677aac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d54a12ee7fb04ab63a97040cd57112a2586c90e5caac21bda420ddb1a90c3598"
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
