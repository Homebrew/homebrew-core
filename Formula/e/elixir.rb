class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "f53d06f3e4041c50e65b750e5d56fec9cc7c6a44510786937c6a5bb0666a7207"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f658905fa3bbbb87baf02bd61f778c3507633613dbd26abf17f43277144a2f1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d50c979816750fcc1d01b0077adcbbdb67733fdab20b93ab8df31cd36cdd51a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "834c20651acacc1842c4b43290b3ab9b532a11206a93de459b095dd519de67f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6de3529eb6bd3e1b7d1250be07e76260252d4a8b3241542f7fc9f24c22dca58a"
    sha256 cellar: :any_skip_relocation, ventura:        "735564dd94751564839725ed32602c57239c2228411f03a84ac591d2d2b5d51b"
    sha256 cellar: :any_skip_relocation, monterey:       "83fcb415d044d73489aa72261bae69674e0bfb654e7201c76cb7b94f76591c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6815feeec4382de5c9ca165b494653d7d6dd83923ea9d215859fbc59c67039fe"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP 26)}, shell_output("#{bin}/elixir -v"))
  end
end
