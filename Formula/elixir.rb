class Erlang18Requirement < Requirement
  fatal true
  default_formula "erlang"

  satisfy do
    erl = which("erl")
    next unless erl
    `#{erl} -noshell -eval 'io:fwrite("~s", [erlang:system_info(otp_release) >= "18"])' -s erlang halt | grep -q '^true'`
    next unless $?.exitstatus.zero?
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
  homepage "http://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.4.2.tar.gz"
  sha256 "cb4e2ec4d68b3c8b800179b7ae5779e2999aa3375f74bd188d7d6703497f553f"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "dbee59c2920e7a4aaa60cd93600758ce76d9379d90e927f3d945e80944d5fa56" => :sierra
    sha256 "df0f1857cc107cce9d3a15b6fc6ca60d534adcaa558849b2607bfab0a2d21495" => :el_capitan
    sha256 "cc1a8f3220148fd05d8f7210cb3cdab81905b96b88586d5347979072683b6a9f" => :yosemite
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
