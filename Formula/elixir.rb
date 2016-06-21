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
  url "https://github.com/elixir-lang/elixir/archive/v1.3.0.tar.gz"
  sha256 "66cb8448dd60397cad11ba554c2613f732192c9026468cff55e8347a5ae4004a"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "cb8f03f115a4ae4bcf164f750446af786ca624004b6cedd3860d1696575862d1" => :el_capitan
    sha256 "1b76f1b3cdda44110ef6125c22fb3a5140cf49ea00e98a64ac82f716bc200eba" => :yosemite
    sha256 "593ec41043a9bc9dc3875243bf964d068e2ebcf6cb433a726ee7ad1cb6410c65" => :mavericks
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
