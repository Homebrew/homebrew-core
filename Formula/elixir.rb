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
  url "https://github.com/elixir-lang/elixir/archive/v1.3.2.tar.gz"
  sha256 "be24efee0655206063208c5bb4157638310ff7e063b7ebd9d79e1c77e8344c4b"

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "f61117e646b400a9526bd3108ffccf5526b65627ec8f001b23aa0efae021460a" => :el_capitan
    sha256 "2bc3d1516b4ce7e35a744a99b8572516c0455e85dd1ad94db880445956d29949" => :yosemite
    sha256 "1379ac7fdccc58c9d406ee5f4b55d59108d5616bd3d7b6a0cec15b8a0e6556fc" => :mavericks
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
