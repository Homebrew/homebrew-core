class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.6.0.tar.gz"
  sha256 "534215b646adef426810a1b371ecdfd087d432ca7b4262cff493dfedbacf9818"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7082f0eb5eb0f4ab3b67bcfc60e3411272388b32e81e4d5954e31fc12a01af11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5031d60300a4bed4adc3bfaa4367d64a1f30f896c632c62bc651f46fd7e9863"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b7bc35cb66bd00fc994a4aeabd31bb593adce49a23c806cadafd53843de24bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8601d7641b785f8336ec6643d6671d3edf5dbf0b02c1e146d3c2d595da75cdd"
    sha256 cellar: :any_skip_relocation, ventura:       "536e3d03ab8af38a5ad474a3e59dc127e40abadf3e4fcc1d457806f01eae1656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39e59384699ca25dcb9e6dde849ef81d980b035902c34b7a602974cb3eea6c71"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
