class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "686592eca1e4d0bac0a29b28825214809d02b6552f2c9fd5e954920632b6016b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "68e6280a21a26a14b22854e9e834c816b4a34dc7a807d16a97d5bd2a6cf6846c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b05cdc6709f0c2053045307bbce55d39dede8baf6efac3ade7b544f300b2f8ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f23c367224830401e4d76f29a02b3e7181d519adb6b5f714121892a90c9fc863"
    sha256 cellar: :any,                 arm64_linux:       "4572932552f2452f4a99175f0600dd1bb3d629ba4c011c85e855757972470cb8"
    sha256 cellar: :any,                 x86_64_linux:      "156e26bb8580554514e0648a507e3db97746815fddc430ea54ade390d9879244"
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
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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
