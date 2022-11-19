class CargoBundle < Formula
  desc "Wrap rust executables in OS-specific app bundles"
  homepage "https://github.com/burtonageo/cargo-bundle"
  url "https://github.com/burtonageo/cargo-bundle/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "1ab5d3175e1828fe3b8b9bed9048f0279394fef90cd89ea5ff351c7cba2afa10"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/burtonageo/cargo-bundle.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80188536b9ea48f4bf2684a94f7a49cede6fa2df3363166d88dd9ab544863a8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2a0a08c3bf07cb9cc441163497d39b59b9c7c4fdad0be8d3c40795b7cc93923"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bd2d974ec9db345d90f862d0bcfdb73b09b829712b4c520522d1c3d1f05badc"
    sha256 cellar: :any_skip_relocation, ventura:        "ada7709197c98af0cda23f5abcb6cf5bbab3b96afef5f607d2a571ef8ac2b8da"
    sha256 cellar: :any_skip_relocation, monterey:       "382768c4aeb9ec456bd70c770a3aff75ee4f8f2cf42f7fe9b8b481ed7f714fb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2698372a48dfea6db720b4cf70c2b7cfa13560798dd17f434e57d59016d7c23"
    sha256 cellar: :any_skip_relocation, catalina:       "c5484070e73f28b33a947fe837f1b727b8329ba3857adcd148a8577cb82ca5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e2f7b9d02ba3b4e0c85d920d779d948a8855ac69b770f1a82720109543d1aa"
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
