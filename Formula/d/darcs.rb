class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "https://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.18.3/darcs-2.18.3.tar.gz"
  sha256 "14abd862927abe4387d226d013a4e6655317f29f8b0721991a17fdd883f8e69a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fb416212ff5a4d443454522e6938697a9d959e2fe3eff545dc2c069f22e96dd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35f0cf18f12c485e5c17c9e40a72bffe3c041bfccd2c52fa6e8c417c83754494"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "beeef441e9e24f1d7a5e72dd5c29188432217aae6b151afdf0d7de17b8c3ca30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d14752765fad87efc247348ed1a21ccd8d4a5521d009a5e60bfeac2c18be725f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b485e4a05ef77b5fdd966d3a25a9028705a25fde4fe466f53a7bf0eeeadd0e0a"
    sha256 cellar: :any_skip_relocation, ventura:        "48df8f4180b112bde9d59dad1c431820b3ad8a24272a4ad685d4bcb0aaad4ffa"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d0cb2a23030f9ed0a267a6ba82fda9bc5fd2625877c174328f0aa2d0ffe7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048f27d034b24f118f8022a96753a58621c801475979e03b4509f381c6b85b42"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "gmp"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    mkdir "my_repo" do
      system bin/"darcs", "init"
      (Pathname.pwd/"foo").write "hello homebrew!"
      system bin/"darcs", "add", "foo"
      system bin/"darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system bin/"darcs", "get", "my_repo", "my_repo_clone"
    cd "my_repo_clone" do
      assert_match "hello homebrew!", (Pathname.pwd/"foo").read
    end
  end
end
