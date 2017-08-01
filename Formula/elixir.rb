class Erlang18Requirement < Requirement
  fatal true
  default_formula "erlang"

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s", [erlang:system_info(otp_release) >= "18"])' -s erlang halt | grep -q '^true'`
    next unless $CHILD_STATUS.exitstatus.zero?
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
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.5.1.tar.gz"
  sha256 "9a903dc71800c6ce8f4f4b84a1e4849e3433e68243958fd6413a144857b61f6a"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "ca8ab373ca0623706abf177adb15919b065c36930f0bfed6fdf6901163a4192c" => :sierra
    sha256 "740afe30e277007ac12e05a0b01e7f2f8b01f0745529357afb49d1cbfaaca152" => :el_capitan
    sha256 "4b2b2a83b99fdf16f12aa33273b6201b6698e640cd6f657f05fc7ffe411e71f5" => :yosemite
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
