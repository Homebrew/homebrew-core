class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.5.37.tar.gz"
  sha256 "0ba906ee94b323c9b72bdae27d74039fb0ab3340b33e6d68fda279b72848598d"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ee3ff9b964a8f5aaacca9b025a007fd5a3de26e13ae2b3643bc209836a38ee5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c960aaa31fa70fee2db8aa386fa709f9b5c26381a6e13e076d9ed522890bf5b"
    sha256 cellar: :any_skip_relocation, monterey:       "66cf63e55f1e90606833d825bfa4545ecad9af41adfda5e59adb40e71c2579ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "39b2007a22fc160c92ab6bf063b9f4249c2b7bb5f167901cc4b27f79f2fcdd70"
    sha256 cellar: :any_skip_relocation, catalina:       "f89c7147e88f58395d56a8f3f9b2e87dd70b458e7147cfc701c8d06d752e9644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf559c32f436b43aecab3bd5db5252850b214a2cc32f5f0ba13e0caea4cc2d89"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
