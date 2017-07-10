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
  url "https://github.com/elixir-lang/elixir/archive/v1.4.5.tar.gz"
  sha256 "bef1a0ea7a36539eed4b104ec26a82e46940959345ed66509ec6cc3d987bada0"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "b59dde1332bce0aabc7aebe9527607adb68dc1c1a8070c2d0c1b1e702511ff62" => :sierra
    sha256 "c994c7a94a52eac63fa0478175f8a0e256b3ef2b73e81f61b67429830fbc201e" => :el_capitan
    sha256 "291946687a7d64541b69a132daab1d400592a115ed02ae1f0116fbe1799aee67" => :yosemite
  end

  devel do
    url "https://github.com/elixir-lang/elixir/archive/v1.5.0-rc.0.tar.gz"
    version "1.5.0-rc.0"
    sha256 "26731f227272aedf11f5ac11887f52b4b478e9c849345515855c01601d5f494e"
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
