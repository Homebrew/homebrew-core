class Luaver < Formula
  desc "Manage and switch between versions of Lua, LuaJIT, and Luarocks"
  homepage "https://github.com/DhavalKapil/luaver"
  url "https://github.com/DhavalKapil/luaver/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "441b1b72818889593d15a035807c95321118ac34270da49cf8d5d64f5f2e486d"
  license "MIT"
  head "https://github.com/DhavalKapil/luaver.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9bf33058878e1a0fcbec847bf8b5ec06912eda98647f05ab96e08e4c1197f93a"
  end

  depends_on "wget"

  def install
    bin.install "luaver"
  end

  def caveats
    <<~EOS
      Add the following at the end of the correct file yourself:
        if which luaver > /dev/null; then . `which luaver`; fi
    EOS
  end

  test do
    lua_versions = %w[5.3.3 5.2.4 5.1.5]
    lua_versions.each do |v|
      ENV.deparallelize { system "bash", "-c", ". #{bin}/luaver install #{v} < /dev/null" }
      system "bash", "-c", ". #{bin}/luaver use #{v} && lua -v"
    end
  end
end
