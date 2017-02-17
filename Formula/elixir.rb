class Erlang18Requirement < Requirement
  fatal true
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
  url "https://github.com/elixir-lang/elixir/archive/v1.4.2.tar.gz"
  sha256 "cb4e2ec4d68b3c8b800179b7ae5779e2999aa3375f74bd188d7d6703497f553f"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "69f0f33e815e75672b0f0af5ec182c085427025c1af558b769d3098e2baa20ea" => :sierra
    sha256 "f9bf63d00a380b69532fbf79675eb22327d36dcff59ded31937c7a61bcc4f6e8" => :el_capitan
    sha256 "6b76a51ceb64e27d7a4296e54eaf14066043a9cc751225c04feb0decd99c8641" => :yosemite
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
