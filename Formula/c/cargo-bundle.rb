class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "0655b249c7c31047d2d0cb2e9b4923a2fb394e7a09a2300fc533de4e38d68d03"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49f92188a9b553281bde3587f9da999927eae7fafc9da9ec18c3f398107315f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8377eb226753d48162ea960f7ccfbcd06df5918467a44ed66e00d6dcd99f3fc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "546fc0d98ab85f734b95bf2912be0045fe7bef3a277e7a9cb085383d11307863"
    sha256 cellar: :any_skip_relocation, sonoma:        "d30f08ea539c9b8f2456f0f76a321f3a2f1d4c3ee826ba3fa11308420f109127"
    sha256 cellar: :any_skip_relocation, ventura:       "fb660dd523d66cf00f67c6e618aa7c68d21dd9c021e3062d2696dcb367b21733"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a2e5e3a80eb8b3fb768725fa47d8f5640c44f9717484b9e4de82ea365bf5623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b8b63d05107a7d76102fd5184e579b431056e5ba56631ca7c96d8be66829175"
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
