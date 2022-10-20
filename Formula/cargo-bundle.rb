class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "1ab5d3175e1828fe3b8b9bed9048f0279394fef90cd89ea5ff351c7cba2afa10"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b61ae9882df00d6d0046316234c806cf51c43487454615c3e1b123ca58253d11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b6767869cb3b938442837576a1f1fd3b22d4599ea402ed5fb660fc8ce632a79"
    sha256 cellar: :any_skip_relocation, monterey:       "ef868e466a16006894d7ca523b67e08f9df892df6dd17430975bf4fe019a10c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3744884442d4629838d985a2b09c2958aee6213740b3d5120d1fad58c860ced"
    sha256 cellar: :any_skip_relocation, catalina:       "459cb6ecd3db66bdb64acb17f6fa0c70bd3e03ae30b6de4ac64a13b8e849af2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35cf4f78ce4b64e81e8946079b09ea0959e1c938c892b70652e241e1c9380ec9"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
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
      "deb/#{testproject}_#{version}_amd64.deb"
    end
    bundle_path = testpath/testproject/"target/release/bundle"/bundle_subdir
    assert_predicate bundle_path, :exist?
    return if OS.linux? # The test below has no equivalent on Linux.

    cargo_built_bin = testpath/testproject/"target/release"/testproject
    cargo_bundled_bin = bundle_path/"Contents/MacOS"/testproject
    assert_equal shell_output(cargo_built_bin), shell_output(cargo_bundled_bin)
  end
end
