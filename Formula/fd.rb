class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/v8.7.0.tar.gz"
  sha256 "13da15f3197d58a54768aaad0099c80ad2e9756dd1b0c7df68c413ad2d5238c9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee1434a07c517a74607aa2303db21ecb738f39b63f5e0a778adfb6a9840fb48a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b58abc8df1995a8bef77969455af0a6f593678b255a6cc00c791072bdc775403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b215aca0a513fef0f54bbc370792ea4344337422351f37fb6e0f4154bbdb05f8"
    sha256 cellar: :any_skip_relocation, ventura:        "27e1506432e3533ee3431bc3e2cad8b9dc579738d9be19a3201c3c85a9114c29"
    sha256 cellar: :any_skip_relocation, monterey:       "c32e108f755510b7aee3649f4f4d095f086c0892a4912302f72c3a4d6ccc4a36"
    sha256 cellar: :any_skip_relocation, big_sur:        "262cddb5efc78d03f059589b4b5b40679ec668db29e2e30296e6d2bbabd54e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b73f91ce0f9f5932282038ca06ed1c8864ef86636822cd80282a4db61d34ba1"
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
