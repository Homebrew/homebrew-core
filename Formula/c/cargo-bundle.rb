class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "8777ddbfaadf4def5f261d37c3b0b04a6ee27cdbd4e18569827ad0dee7e35b34"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4314c3eafa5f0f536d922ddfb69008be6c35a47193f1a9eb224d8f0fad787c28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dfb4e342067506ec34a71e1c078145b8928dff18322a00ac9f831b7590a1722"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ef15f006adb11984837907dff71478d2cf0cac5069ad66e86e5f6576fa27d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a18a9459c1c400d12e5ee3c4f151bac8c933c123434bed9db7d5bf98d44b5f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd9635077c69ed673b0eb30fc744faea59571b0778aaeffb2a3aec9bc95ac5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1a6bb6315ed444543895c018728a36dd13ac589bdd38a33feb0778f9eda2bb"
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
