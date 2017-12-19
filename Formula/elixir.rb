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

  def message; <<~EOS
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
  url "https://github.com/elixir-lang/elixir/archive/v1.5.3.tar.gz"
  sha256 "0fc6024b6027d87af9609b416448fd65d8927e0d05fc02410b35f4b9b9eb9629"

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
