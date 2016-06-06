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
    sha256 "cc1704fe65472776701b8f94417a3e24194d739306d62b045d8635652a535c56" => :el_capitan
    sha256 "f541dad4343aef8d99578cc49a85381a0a81e4071d9a9f928e957c380270f3e1" => :yosemite
    sha256 "67e5e7cb245c218995c431c6ed0ebec4921315aad747783616fb4b770366826a" => :mavericks
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
