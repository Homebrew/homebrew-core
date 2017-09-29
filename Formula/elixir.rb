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
  url "https://github.com/elixir-lang/elixir/archive/v1.5.2.tar.gz"
  sha256 "7317b7a9d3b5bef2b5cd56de738f2b37fd4111e24efbe71a3e39bea1b702ff6c"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "a73f29068edcfc35fd5adae518eb563594bf154368b0ebcda8fe24d0c8844b74" => :high_sierra
    sha256 "2e2bc323b22c0618d324fd0fd0ecb41d10eb2a0f8c157b9dce161db9ef708321" => :sierra
    sha256 "a74d9912c1ef658626a400d37a8df162d1f6e0d8337a80963dc289289931920f" => :el_capitan
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
