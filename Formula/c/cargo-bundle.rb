class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "686592eca1e4d0bac0a29b28825214809d02b6552f2c9fd5e954920632b6016b"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd88e7255e722bc01364958afb0af26a55b7ab5022576a8c7ef0c9e5a8bff0a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6cd6e199ef1ec95a34aaa6fc0cbbe4883f08481b99fe05ad9be1ab7712aa6f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "265625df34d3dece4148cee7f08c9d9d1b376e9ae48bfb473305522141e76f5b"
    sha256 cellar: :any,                 arm64_linux:       "2df287c9e1cf0525c2fe3be957ed789666a2ddc68c9f77fe0ca7b9568945f122"
    sha256 cellar: :any,                 x86_64_linux:      "99d8cf87f996786235b96e5a4c1761b9bc58c50115da3516227775fbe0620807"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test

  on_linux do
    depends_on "squashfs" => :test
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    # `Cargo.lock` file is ignored
    system "cargo", "generate-lockfile"
    system "cargo", "fetch", *std_cargo_fetch_args
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
