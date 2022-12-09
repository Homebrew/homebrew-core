class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.6.0.tar.gz"
  sha256 "e71a139f9ca20f63bab3700d5f8810bc12ef2c4fc6e1dd680f5c96fa9d1d2834"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ed464d2b4fe2ca141e532b001b0e5c1ab2579fc6e53a2b78f75772483036ca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aaf07cd8636a9e110f7d21f2e14c3ca8d47041248897bda57edcdf876f3fd85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b43cfc97e23061fd573acd571e41dd02c849c5d1c0c237f3cd0737a737a252f"
    sha256 cellar: :any_skip_relocation, ventura:        "b741bd5c98bfd8fb5d7f40fcb48488316753784f496cf2f7d0e513b82c948129"
    sha256 cellar: :any_skip_relocation, monterey:       "ac29c5b233e3db78b774ae34feab864f7ad1cf1578a0c6d90474c00963c2f300"
    sha256 cellar: :any_skip_relocation, big_sur:        "61d5b5be009114f07a1f306fbc7636a99d9cff88a58ea4c6986aca74a50c9272"
    sha256 cellar: :any_skip_relocation, catalina:       "08fab3dd84b298c2a32617608d2154cfd6c2e57bbc8147a6bddb9560ce6d20a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caf5cdc827f3c05037f9639228a4807b6aefd7a79576b63f83c765e7981dc021"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/fd.1"
    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish])
    zsh_completion.install "contrib/completion/_fd"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
