class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "9e046a6dbc6eeda3ba58e9c733d5cbdc0a7dafab212786beb0b47534d8673f3c"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acb39e07b16d14f86542190d354f755d23343aafa13574c55aace0ba6ff31a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05640ec57528a7c4b1815fdeb3c54cdcb0f98359a7985734f77cd72249af83d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c25e653a2bc5d6777eee13a25d1221ce5b449e801a9f817505015c2a93715d98"
    sha256 cellar: :any_skip_relocation, sonoma:        "d25ec180b3628087b334e2a6895de38b7342386be66390a0633a51dcd0cb4b8d"
    sha256 cellar: :any_skip_relocation, ventura:       "235dcfc515c7c5e59f4740bb7a0d56a1894f91071d5859389906aa0f19306cc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "904ee4dc83bb00c1099e68d1e519fa73091e072591ba83de47d9eeca0e9716ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab866d24948b6d2a4e91480208e963b7a43a7f225f51acbcdb714139dc6113b"
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
