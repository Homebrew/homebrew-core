class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "04555c9518368c1f8c3df12a1370fd3b9458c95e36beebb1ea6aeee389415c77"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19aeff792b6925b66fa8795bf22cb0f81b2da5b732e6e6ee5bc92acd3fe927d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3c671f2f12dbefbb784fe58ab9706df7631e5ce1d046b5be25e2d49b036ca7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16037905e65816b6373f5d25d49a6bc43cb340e9281f603a0e0766d4c4878ad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5bbb5bce277ee4914c5577513fc183bcc9f0b6c8721b51f6d0b8709a2263f29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "462db000c7a1daa426b8fbb726a196706cdcedf7ca917287123541d8df0a34f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2909696ee98c76ba6fd608f9c90ce2ea376fa12baaf381fb237fd9a5c8ba55ad"
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
