class Erlang18Requirement < Requirement
  fatal true
  env :userpaths
  default_formula "erlang"

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s", [erlang:system_info(otp_release) >= "18"])' -s erlang halt | grep -q '^true'`
    $?.exitstatus == 0
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
  url "https://github.com/elixir-lang/elixir/archive/v1.2.6.tar.gz"
  sha256 "2fd4ed9d7d8b4bd9f151cdaf6b39726d64d7cf756186a5c9454867514e5b0916"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "491077358775db7da17c236f099631c33eaa0e88ac156e4924d5b509ae2d315e" => :el_capitan
    sha256 "1cea1552d34a5a1d4d3debac14bda312cbfa21336fd6cd0723489f68d61cb93e" => :yosemite
    sha256 "138f40b57643ff60d037907277fae8f70e54125be941247fe7ea82e196ffc70d" => :mavericks
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
