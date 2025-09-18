class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "14fac75769f8e1797dfbc43c9c27eaaaccfee1008b9d80ccba53571d6a7e216a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7896768d539ad938c9e24a3bf32f453564ef3cb88521c858d76f35827fc1e23a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bf9ca36ac3ef881e11a03840554826dcaa0a99e6f7e47036203216b5e5081ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ced991acef5a37431961520411fd8d4f87507e0d7d633c1e42470937785f782c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc6a9631c1ea928a79cad86aea6b0b9782e2366844113eda9f53fddee2a77986"
    sha256 cellar: :any_skip_relocation, sonoma:        "053ac453fe329158b35d5ab40d18ecdf06ddf68147ac9d725bfa34ccfc49a0a0"
    sha256 cellar: :any_skip_relocation, ventura:       "c8f3dba52625aecdcc6d42700430c1b5d0aa176fff9ae34c21092ed10f583abf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12cc559df1d00dce32b03f09df473cff46e129a089193631c159c489e4b7ffcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8354f3f5fdbb63636f1cfe5de4b258a5a149a642dcdb54a485f7b5db1fa8685e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "squashfs" => :test
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    # `cargo-bundle` does not like `TERM=dumb`.
    # https://github.com/burtonageo/cargo-bundle/issues/118
    ENV["TERM"] = "xterm"

    testproject = "homebrew_test"
    system "cargo", "new", testproject, "--bin"
    cd testproject do
      open("Cargo.toml", "w") do |toml|
        toml.write <<~TOML
          [package]
          name = "#{testproject}"
          version = "#{version}"
          edition = "2021"
          description = "Test Project"

          [package.metadata.bundle]
          name = "#{testproject}"
          identifier = "test.brew"
        TOML
      end
      system "cargo", "bundle", "--release"
    end

    bundle_subdir = if OS.mac?
      "osx/#{testproject}.app"
    else
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch
      "deb/#{testproject}_#{version}_#{arch}.deb"
    end
    bundle_path = testpath/testproject/"target/release/bundle"/bundle_subdir
    assert_path_exists bundle_path
    return if OS.linux? # The test below has no equivalent on Linux.

    cargo_built_bin = testpath/testproject/"target/release"/testproject
    cargo_bundled_bin = bundle_path/"Contents/MacOS"/testproject
    assert_equal shell_output(cargo_built_bin), shell_output(cargo_bundled_bin)
  end
end
