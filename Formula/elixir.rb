class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.13.4.tar.gz"
  sha256 "95daf2dd3052e6ca7d4d849457eaaba09de52d65ca38d6933c65bc1cdf6b8579"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "463486dc9feeae42feedc2081d5d8a4453049ccc9378ff7d499d69e74f5d9e5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53f1cc0ba551cf479e8a94bf37f8a9cb81fbe947b167f01eac720e6e77837be5"
    sha256 cellar: :any_skip_relocation, monterey:       "34042b6dffc153355879c4f7e626729cf3d26e4b4ca2cafead11c27fe94ce50a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc58982b64740829904dbf23e621998bc29df54fc46275532803dca28f56921f"
    sha256 cellar: :any_skip_relocation, catalina:       "11560072909428556a398a7578485821f678f1faf85f9ca94ff48fc400c013c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "269ed963791ded716de20ad620a03a12bfb70fc9d44c61e37cb7ebd881407dd8"
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
