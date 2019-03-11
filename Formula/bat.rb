class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.10.0.tar.gz"
  sha256 "54dd396e8f20d44c6032a32339f45eab46a69b6134e74a704f8d4a27c18ddc3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "36855c4b2616e0ef2fda032a1afc71f6be5abb6dee6c38376072cab1fd2b7e4f" => :mojave
    sha256 "8a661ac036f0419b2959386eda537decb58b6bd614bd95bf7baeabed2287263d" => :high_sierra
    sha256 "4a64a65453b1301cb01a784d8f5f1857f6904b7963032756a948ba79efc2bf51" => :sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
