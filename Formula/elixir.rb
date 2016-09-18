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
  url "https://github.com/elixir-lang/elixir/archive/v1.3.3.tar.gz"
  sha256 "cc9d29a007bec69c51eeb0ceb226c55a4c26f20d6f4eb485fd0e72bbfeb2777b"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "d9b7ea39c35b8148a5a7620428a9cb29d27fd63d6d67b1e15f0776a72929ecbf" => :sierra
    sha256 "48cf90eb8e383666b6e2ef3fd6115245cb6f19cfacd685103805e60bbb6f850d" => :el_capitan
    sha256 "bed7525e4688cf61f18852e52074bac51de329a33febc53c739aafff659698a3" => :yosemite
    sha256 "372d04933da019faaa04ad0fe84ae84baec31f83062ea5d419e0f0cfd9a51e4a" => :mavericks
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
