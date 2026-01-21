class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "1a7e3b00b6103c2c7ccca0bfba48001ef98c80e9b72be7cf5ddc99953ee8b686"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18024fdd034df07f4f212e1e96eed38cbf907cf8fa4c23936d7c9968a4110175"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f61e5f3fd820588bb6bb3154a1fa886ceffdac6dbe08ee0232b8e229603bc350"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3e58a2a825b4734243830164b799c9ed984ff37148971de7b3b245d702d5cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "23cf9e4cb6f815e64be3376a35c344a412a277bd98c01cb7d19395f84d809c4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f0ff8184e34a1604b931c57c132e56761f181ce07e602afa640ea57b7254ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afca1a869aff37054ca4ebe855200c30785ada31b456be07198dbc85e40908b4"
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

      # bear is unused
      assert_match "unused dependency `bear`", shell_output("cargo shear", 1)
    end
  end
end
