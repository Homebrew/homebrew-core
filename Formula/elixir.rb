class Erlang18Requirement < Requirement
  fatal true
  env :userpaths
  default_formula "erlang"

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s", [erlang:system_info(otp_release) >= "18"])' -s erlang halt | grep -q '^true'`
    $?.exitstatus.zero?
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
  url "https://github.com/elixir-lang/elixir/archive/v1.3.4.tar.gz"
  sha256 "f5ee5353d8dbe610b1dfd276d22f2038d57d9a7d3cea69dac10da2b098bd2033"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "4bb3b36318c66b031d8c3cb376cc0a671b37eb5907d4dd9b308cb07c982b08f2" => :sierra
    sha256 "864a9db3635d9238227d7b1ece217358cd4dff22fd6d3dc1e92f5f70d04affee" => :el_capitan
    sha256 "49afc0190b5d23a332b286dcde11d171478893d727c796d62bf81ac632595aa6" => :yosemite
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
