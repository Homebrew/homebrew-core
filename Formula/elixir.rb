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
    sha256 "cd8180d172690bbdcc4a8b03e7e0c378d43b4072c7a8660f6c96fb5cc70e60d2" => :high_sierra
    sha256 "4e1bb317a240e858f5791501f1394f6b44305a9fd2de793b15b3a3a1978bd207" => :sierra
    sha256 "9041f7d6ef531f64ce516d8d872faeb27b6c249153286e00f37f7a7b668daab3" => :el_capitan
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
