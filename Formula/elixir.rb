class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.12.1.tar.gz"
  sha256 "96167d614b9c483efc54bd7898c3eea4768569a77dd8892ada85d7800d5e3ea4"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "177ba9120974a38bd03758aa2b7a01b185d820314d91b99c3548a24540be9d47"
    sha256 cellar: :any_skip_relocation, big_sur:       "7e01d30a6aa297324b2377e0e787a40786abf8c2a62fd6168e38125e44bf2a44"
    sha256 cellar: :any_skip_relocation, catalina:      "ee2d33e2ad591c848a1a3bf14e0447ee4461947cda2d1c871573603859e827bb"
    sha256 cellar: :any_skip_relocation, mojave:        "3de7660ef2330a2b348829bb14215cadeda23325991e6d8d008922dfaafac984"
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
    system "#{bin}/elixir", "-v"
  end
end
