class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.13.1.tar.gz"
  sha256 "deaba8156b11777adfa28e54e76ddf49ab1a0132cca54c41d9d7648e800edcc8"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924e318c70b4fbb380a5dc40fa73a764c331dc0983721a57899c58e3674d9ac6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89bdf2bcc22784386070d7727bd2bde067ce55ab220da29282fc65d4645b9afb"
    sha256 cellar: :any_skip_relocation, monterey:       "bd8a66ffacbfdada872cccbe9c6f72af4e5c2fcab7735a6513be66bf98644915"
    sha256 cellar: :any_skip_relocation, big_sur:        "b04829c5bd65aaf7c4526f5dd1949c720bc6a5a78475972e775c9a714644613c"
    sha256 cellar: :any_skip_relocation, catalina:       "280ae55c671eafa4c96b81ef04c54404644db6dc94adb84c0006d2cc00ffcf9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "142a5d6a3feb81a66222fb6cad375ffcf50eeff4bce610bc996400b961c25f46"
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
