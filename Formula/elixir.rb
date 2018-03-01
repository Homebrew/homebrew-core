class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.2.tar.gz"
  sha256 "64779258e60ddf220fde75c9d972c00ff7760cbd0edbe555c93e3f892f8b0726"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "460378c0bc6950589fb0137c25d001996f2bcfe7e10cf8b369c8162fe3c44bbc" => :high_sierra
    sha256 "cae606fc94abf5568befec6c94ca8b0df1b2c8561daadfbf72121e59a698226d" => :sierra
    sha256 "34aad70e46078acbce635a08818c56e08d4a9734c09848fbbd4c2cd6b715e957" => :el_capitan
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
