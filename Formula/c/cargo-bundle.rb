class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b97d0abdfc97c3ed17bba5c07ef97f0daeec39b938e507735d109dd96aebc8b1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d90ead8844e0d2a937132fb9f59a6d547f024efc24e2d8e1e84fe1d39db53748"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1244930efa3939e12dcbdf74e4195e0330491d3f87d504311e511d17a526e315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2147b5460f747be986c3930c64622e744f5a21e77cf16e29a3ed75ff0aa41b71"
    sha256 cellar: :any_skip_relocation, sonoma:        "a25d957a67641f4bf3ed6ab61462a72aed20b13bf7c9013d98c536b23f7bf670"
    sha256 cellar: :any,                 arm64_linux:   "c85d8f26eb34760821105d9f8b48a96ff609fd0f20e41e438501d0f0652cb7fc"
    sha256 cellar: :any,                 x86_64_linux:  "53e8cf1605f5eadf0a26920e2c5477cca6e9411e46629e83b7c71c9dfa596232"
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
      system "cargo", "bundle", "--release", "--format", OS.mac? ? "osx" : "deb"
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
