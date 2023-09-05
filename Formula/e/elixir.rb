class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.15.5.tar.gz"
  sha256 "69f6203eded2d5b2d246c807528f896b3d352141c9cf3e095762748d677c7260"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96cccd801f0ca2e305a6267e2ecc6cad6b6ceb44615207ac25e7590e23350658"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b6c5f4f35030390475fcaa6f793e010afc9121b71a8ceabe362522f9749e83c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e67e1ba52ccf51eb3ed52e1ae9cb1144ec2509ae41955e0120d2097b3f19c42"
    sha256 cellar: :any_skip_relocation, ventura:        "dc448c4a67525d49340437eb5db5751a5f4a05967ed0e19fa7f54ab6c06b6926"
    sha256 cellar: :any_skip_relocation, monterey:       "20efefecc87a946cc41a742edfde6fb233669cfb1648fed12599fabdc842d71b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d40ba51429025d04cf3e40e77b9a32317c0d0839a2d85b73bfc66581432340bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391df9544f4885174ce00204e0050f6962a026165ef6aca86e4c28dd8ae2b895"
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
