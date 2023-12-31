class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "d7fe641e3c85c9774232618d22c880c86c2f31e3508c344ce75d134cd40aea18"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bdb71fc352cd5d9540c2dc46f2d6bda51c7a0edc33d64b32a971746ed9138702"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aba19013fa3d2a7f258b69ab0ae4fca2716975cc9e243a9af8a1406209a71ab2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff113166a11a5f6364c5c72a2b8d4fef997b452bc2e21d60cdcfa77354009b5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "42280acfcc795fe774b3a7f28dfd678fcbf1c9afb6a378bdf8af97adf2e10507"
    sha256 cellar: :any_skip_relocation, ventura:        "8a46930335a07c245697a2643b7e4a031cf271437b40484e47f30a469976da7b"
    sha256 cellar: :any_skip_relocation, monterey:       "83bde441c7f61858282dbf847d9b37380a049943a25ed366fb55b0e2f989ded0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06036781b35b11d60ba5464b9e9669ec3df0db126021297685aa946b1d940152"
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
