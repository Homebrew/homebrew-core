class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "18270c983636582c7723b2b6447c76330d8372feb53140eec693f6c2db5e7e81"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "97cee1a83c22efbcaac2b88f29faf09ff8f70957ae9150c3ac6bf645151f7081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d7d7fd8160402ae2884ef7e88e95cdaa56e163b62150e325c306ca1a2879927"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aed77abf521dcc180bb87fe548ea79961d328c5443753aab5e982e46d0667a65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa10b2892b2f4e59f8e5fb24921a07b70fcedadecc3e83c266e4c0da7de1b6d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfbb27620b4052f85a3e950fde37d646c8946f3f99f221026f7432b04806b606"
    sha256 cellar: :any_skip_relocation, ventura:        "dca1765993664c75a803ad7570df1743e5c97b2d6d22db5a765ce6965f05a747"
    sha256 cellar: :any_skip_relocation, monterey:       "f5cf9c786583b5bdae6755e9b44610a13c16a3d27b88a4b69829936a2bb9f702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d1c04a423a5f9d8c17dc4cd83d7a2673c45f23f727e64a45f50dde0cdd0aa4"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
