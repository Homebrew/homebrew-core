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
    sha256 "249639d1f2c0b2d5815abc07766aeb6fdf0358485e65a270731499f667de4e45" => :sierra
    sha256 "743c796575d9db10c6fd6628b8b119d1cc8f0ea4ee437d66f491cdc28e3b3832" => :el_capitan
    sha256 "792ff99038a291c890a842ba82a28b41532adaf89ea7eb977a4f7a247a21d917" => :yosemite
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
