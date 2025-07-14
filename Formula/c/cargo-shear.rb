class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "06c2b5b88dc376c5d580d4d0a02deff44000516723d96984c89bd31655dc9365"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d5dcaa07bc7abcff5dc13af190deaf8e23dfb1b35df088c5af19f0ad7310f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "157b379ebcc908870cf343640582ca70c2d6028be3c4c12ccb21d4068f5bba54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5223f5805a36897e47162da61ed362e4d62bc1a04b51104140a2fdabf77ddf44"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e11b21166937ced5cc5f5fb92e95a77755fef47106f9bab7d7545c9f90c57a8"
    sha256 cellar: :any_skip_relocation, ventura:       "3e823546336331575e534591c4b47acf1947daed9fc37e0d2f3368cfd4452196"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afeb689dad41c07cb0dbf043471b0f565aa023adb812f1dc5fa582646fcf444c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6c810221667d2e933c07e19ab1a747aa328acceaac313d38abe3092c2644213"
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
