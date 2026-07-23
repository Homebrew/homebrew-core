class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.9.2.tar.gz"
  sha256 "26f92d8463ad823dc79089f2bfb9de6667d607fa1250ea5d4ab1bd4ef86942a4"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f152fc8cfc9edb0b56416a78c616dccd0d2d1519105e6fb5f112a0fc967b454"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2097c6abac7a240b8e8d734f47905a5842a7ae9192b01f51da854ce26fc54b79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "728de4d20ffc429b5f8f1b7b364f103722a8e3a956f1104cadf85d42db3fd5d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e457bae6b4d726b565018b83adb58413d4a8f493d25ef9ba9334aedad965ef9a"
    sha256 cellar: :any,                 arm64_linux:   "6b15fe5efa75c02ca6f663c1169eab4c72d216e01911e4abfa44d2ec1adf9897"
    sha256 cellar: :any,                 x86_64_linux:  "47317db9cea8566d2d9d22d211bbcbefcb167715fd92872557bd6bc715a8d13b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
