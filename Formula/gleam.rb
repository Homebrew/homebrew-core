class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.14.4.tar.gz"
  sha256 "547ba808649c05bf670a98a792890cc2df1bc611245b61c6f19567a99a963ee2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b99feb0052578a7fe3691c0521cdc412e32b8665ebf34f238da7f22d5654b8f"
    sha256 cellar: :any_skip_relocation, big_sur:       "81676e0637704e450b03394c942d8cea82470a9553b1865ffb70ea6fa96f6d5d"
    sha256 cellar: :any_skip_relocation, catalina:      "df9c355eaadfd38dbb699c819c7eb570c85ddee6aad96635b5208fbfd3876e83"
    sha256 cellar: :any_skip_relocation, mojave:        "68f6d758b16fd44b39e807403b2293946e856811fb3444c210f75d6cc500274c"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
