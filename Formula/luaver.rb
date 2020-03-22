class Luaver < Formula
  desc "Manage and switch between versions of Lua, LuaJIT, and Luarocks"
  homepage "https://github.com/DhavalKapil/luaver"
  url "https://github.com/DhavalKapil/luaver/archive/v1.1.0.tar.gz"
  sha256 "441b1b72818889593d15a035807c95321118ac34270da49cf8d5d64f5f2e486d"
  head "https://github.com/DhavalKapil/luaver.git"

  bottle :unneeded

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
      ENV.deparallelize { system ". #{bin}/luaver install #{v} < /dev/null" }
      system ". #{bin}/luaver use #{v} && lua -v"
    end
    luajit_versions = %w[2.0.4]
    luajit_versions.each do |v|
      system ". #{bin}/luaver install-luajit #{v} < /dev/null"
      system ". #{bin}/luaver use-luajit #{v} && luajit -v"
    end
  end
end
