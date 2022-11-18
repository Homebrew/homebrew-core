class Difftastic < Formula
  desc "Diff that understands syntax"
  homepage "https://github.com/Wilfred/difftastic"
  url "https://github.com/Wilfred/difftastic/archive/refs/tags/0.38.0.tar.gz"
  sha256 "0f7bc54875939a6a4d2d695f2e94d30573818d72b88c00f38b0bc502f79671c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0017b5a05dcea32d56ac71cdbd9f7d4ce5d737c933a566468dfd9bdf20cfc55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78e7e8b45278cd09df8f14da328355c7e65c9e7298009caee664ee8a9c80517a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0864b8c676baf4774af2f61a635df75c955a9581e3acb02f3dfd7cc4d5d2720"
    sha256 cellar: :any_skip_relocation, ventura:        "f8e2fd97aaf374a1899db773974055c2c889a9fa82a26e482ab06b2bb349418d"
    sha256 cellar: :any_skip_relocation, monterey:       "468b789c73faac9d202a9b56a555d5416f0cb2a67facbbc1dfe5a3f0f1bcccf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2f9afa3f83318ceeccdb18449b067c9dd41391032718c55a9a2c4f2f584373d"
    sha256 cellar: :any_skip_relocation, catalina:       "89a6094e5bfe914c7a6f2fda46c64aeacd801b924e3e894698103c3bdeda47ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd536eb63b137ad93a580c2713b8015909ad1dbfb2a168a40385c50bf2912900"
  end

  depends_on "rust" => :build

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"a.py").write("print(42)\n")
    (testpath/"b.py").write("print(43)\n")
    expected = <<~EOS
      b.py --- Python
      1 print(42)                             1 print(43)\n
    EOS
    assert_equal expected, shell_output("#{bin}/difft --color never --width 80 a.py b.py")
  end
end
