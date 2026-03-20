class Fd < Formula
  desc "Simple, fast and user-friendly alternative to find"
  homepage "https://github.com/sharkdp/fd"
  url "https://github.com/sharkdp/fd/archive/refs/tags/v10.4.2.tar.gz"
  sha256 "3a7e027af8c8e91c196ac259c703d78cd55c364706ddafbc66d02c326e57a456"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/fd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83d0c8ab8a95c83b6feccc78865996a865a6c4dd43b475e6dad4624faca0fbc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "702a6d8e88ca21cb61fb0a05f6cc08bc5238ebf8cc5c3f52e4836f742fe7f5c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c582c3e0ad24abcad44108598822fe746b4c3859b45e85a0be5c4ccdd786c76"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5ef209dd97a44f0adb952af33c3bf88b76cdb716cd52c1c172f798aa5890cb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a481618eccb1c59d8350fc0ab4bd1099f7646c04f9eaaa8d139d95445ca77769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebfd9404fcc55cd20fed3bd149fc948fd6f127abdae785f0b9b786054571b615"
  end

  depends_on "rust" => :build

  conflicts_with "fdclone", because: "both install `fd` binaries"

  def install
    ENV["JEMALLOC_SYS_WITH_LG_PAGE"] = "16" if Hardware::CPU.arm? && OS.linux?
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fd", "--gen-completions", shells: [:bash, :fish, :pwsh])
    zsh_completion.install "contrib/completion/_fd"
    man1.install "doc/fd.1"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "test_file", shell_output("#{bin}/fd test").chomp
  end
end
