class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.14.1.tar.gz"
  sha256 "8ad537eb84471c24c3e6984c37884f06a7834ff2efd72c436c222baee8df9a11"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90b3ec6264ad38ec73c7612cfce7d3f6b9738a66156c63e8896827c298c335ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "419ddd38f0070c9a4742a7153d9379e28166923119779b74d7d96e7c240c007d"
    sha256 cellar: :any_skip_relocation, monterey:       "2b15f8f6aba2a99af34a32676bae9e27749151c311cae54b5c484a0ad8df106f"
    sha256 cellar: :any_skip_relocation, big_sur:        "32933c532e5fff3b91922d6e6d9bbadd1fb41408957508e1296d735778c604e5"
    sha256 cellar: :any_skip_relocation, catalina:       "cc3f455ff4f77f53c53854d924cea5d0564b7266d6c4a28ddc7bf3078df414e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbcae8c2219987f2df81cae6003943fee3f0e40b9558f27bb8ae80cd188f88ea"
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
    assert_match(%r{(compiled with Erlang/OTP 25)}, shell_output("#{bin}/elixir -v"))
  end
end
