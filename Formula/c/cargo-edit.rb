class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/refs/tags/v0.13.7.tar.gz"
  sha256 "f242010b4b0b8ccd245693858d26a35f70bef572a209f4977d192c1215e861c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6390900117e4d1ba9fa0d8c98af2c6f6c933fb5fa074f9dc72222ec507cccc0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4dd153dfa28471eea43c902a5d5c53227593bdf045813fb8b4c8412135ecc94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5b4453832e7c496de84ab14ad158088979f6400f44d5878e92c0990b28353c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "801024abe23a78a5c9a8d3b6306f61efee53301b891aed4e02c60da1f79aa9d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e9919430c3cf41763128c572f7fd539c8bfc37723f58613bb80bf189e370bf6"
    sha256 cellar: :any_skip_relocation, ventura:       "f6d9c017b73a2620fbff53e05a218869695aedc66c59df1574f73125e7c9e351"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3730ef254e5450a69a9ca40b39e8aa032b0bbc6588aa36c26cb9bd3ca28648ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d9b69b980cd929b8a69f9f1c6bdcee2286b4e698f8bdffc1c3bf7d68b34802a"
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
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      TOML

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system "cargo", "rm", "clap"
      refute_match("clap", (crate/"Cargo.toml").read)
    end
  end
end
