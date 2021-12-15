class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.13.1.tar.gz"
  sha256 "deaba8156b11777adfa28e54e76ddf49ab1a0132cca54c41d9d7648e800edcc8"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d30f33d2f796aa44d04e8f0f368172b34edd1229112a2db6dfb6afb8b64291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ad9ddf29ca81ac836b8701872bfd693a0ca9ecabd2cf66fdbb219d081f71e0d"
    sha256 cellar: :any_skip_relocation, monterey:       "b16ee1359107e8599ff6d8befd23be7e8fdf5df5dd6977cff358c556ad45b5db"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac9156cf230a18d1018e6de949b11d9a1cc5df87bc3b731c1bc38468be10c30"
    sha256 cellar: :any_skip_relocation, catalina:       "46f3c11aa0721d91546a394691ca0399e4632f28e87e850ff3630cd98d906335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "054e2101da1f98e144894fafa75703fc15026d7ebb49ecae4a4e96d6675b12b8"
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
