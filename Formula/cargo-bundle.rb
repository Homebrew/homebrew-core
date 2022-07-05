class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "1ab5d3175e1828fe3b8b9bed9048f0279394fef90cd89ea5ff351c7cba2afa10"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

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
