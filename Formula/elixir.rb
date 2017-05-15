class Erlang18Requirement < Requirement
  fatal true
  default_formula "erlang"

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s", [erlang:system_info(otp_release) >= "18"])' -s erlang halt | grep -q '^true'`
    next unless $?.exitstatus.zero?
    erl
  end

  def message; <<-EOS.undent
    Erlang 18+ is required to install.

    You can install this with:
      brew install erlang

    Or you can use an official installer from:
      https://www.erlang.org/
    EOS
  end
end

class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "http://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.4.3.tar.gz"
  sha256 "f4d28a12bdc9fdf007c33bc8855b75e233461446bc92f37847c031d1349df826"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "918584f16550e4eab93d548d32be94af6c5ee71c188dfa682de3d0f7de0f92af" => :sierra
    sha256 "045318076327f1ffdb7f56512aebc9e8a7ac60f40419c7142f1b98140d25bd43" => :el_capitan
    sha256 "3177f3a5c46a039ed989de37702e8525c10828269aba63e5dc707554ff0e73e5" => :yosemite
  end

  depends_on Erlang18Requirement

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
