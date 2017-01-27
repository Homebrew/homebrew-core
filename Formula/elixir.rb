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
  url "https://github.com/elixir-lang/elixir/archive/v1.4.1.tar.gz"
  sha256 "0b8e9e8340b9649c761d2514a60455a290c145732907574ac085b0f7a7e7829f"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "cc34c43d438eaa12eef5f38f9eb9c3a039e8c9377b592eeff86790c58919aee0" => :sierra
    sha256 "215b0b4e6ca9769201d9a7be45dfea1159fce074a33cba1b0272f3ca0585b5bd" => :el_capitan
    sha256 "7d660aa3909934a3285ed485493167268e7a2ce6d4bb60fd370ce2130dcfa97e" => :yosemite
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
