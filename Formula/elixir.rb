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
    sha256 "83e4a920d648d541288dd73b6cc19cb4d91a54e703609320e806c2efd6000466" => :sierra
    sha256 "88f24d7781e7191d94b39fc36464781385a314656bb6900f42cbd996654b579d" => :el_capitan
    sha256 "0d59995085bcdbdbfc08a6467ca99934598756b663c603cffc9103a96b36ff44" => :yosemite
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
