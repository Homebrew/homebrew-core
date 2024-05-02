class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "f53d06f3e4041c50e65b750e5d56fec9cc7c6a44510786937c6a5bb0666a7207"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fb3a98957712f755e554f3af575b95c15862a710d225e21538df3365d0e8847"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a073e2f627cf227caf6a827ecca4970f93f612d9d68049ff42b6d396c04cd0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "215bcfdab0f32085a3b3da90581f07afa89c37ceed3d89b1a91168a081b235df"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8987062fc8366740fb48e98a7f5b2720c96824c9dce599a57b72cc38a9e259b"
    sha256 cellar: :any_skip_relocation, ventura:        "541d8cf0d843424527122d38253c73aa5d3890b05b6b5f01d57f3e0618413a53"
    sha256 cellar: :any_skip_relocation, monterey:       "e77fb13fc651af06d5eaaa52833cc31b1f4ed2e9b25ad29588e00ae05ef1f012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a392d6b61b4641d12088d8d1045b6edae8dd86c36c15ddf3cb8e9c051e2459"
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
