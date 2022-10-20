class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "0506ade022a7e4be858cdc4048d82a80587f9ca7ebd78c5a652baa1e967cf41e"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "493114022fa2da300e062dc36f47d6ac315455c0f840aa9a18299103b85205f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edc44bf9d78e0e61c7519a226f987b9826163eefcb9481af83c689d32906e3c9"
    sha256 cellar: :any_skip_relocation, monterey:       "c29898cd94bdc158267567b3628382c0a062e78663cadc2f207c1ef8e7720c63"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5b7b0cceaef4516a76982fda2fb09c97eff6b9e317a4f4e721504ad54bf5775"
    sha256 cellar: :any_skip_relocation, catalina:       "07f21c7b2328d65c1075d0706b62dc7f452704e60e528124d8611c55d13b67e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f33d3c5149712d7b33d8286e14e279bc4575a81e615eff727233b4c5da09e3aa"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)
  end
end
