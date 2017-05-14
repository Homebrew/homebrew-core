class Luaver < Formula
  desc "Manage and switch between versions of Lua, LuaJIT, and Luarocks"
  homepage "https://github.com/DhavalKapil/luaver"

  url "https://github.com/DhavalKapil/luaver.git",
      :revision => "61861f2a966645a663971cd4e26d2a6104d075f6"
  version "1.0.0-p1"
  head "https://github.com/DhavalKapil/luaver.git"

  bottle :unneeded
  depends_on "wget" => :run

  def install
    share.install "luaver"
  end

  def caveats; <<-EOS.undent
    You should add the following to your .bashrc (or equivalent):
      if [ -f #{HOMEBREW_PREFIX}/share/luaver ]; then
        . #{HOMEBREW_PREFIX}/share/luaver
      fi
    EOS
  end

  test do
    lua_versions = %w[5.3.3 5.2.4 5.1.5]
    lua_versions.each do |v|
      ENV.deparallelize { system ". #{share}/luaver && luaver install #{v} < /dev/null" }
      system ". #{share}/luaver && luaver use #{v} && lua -v"
    end
    luajit_versions = %w[2.0.4]
    luajit_versions.each do |v|
      system ". #{share}/luaver && luaver install-luajit #{v} < /dev/null"
      system ". #{share}/luaver && luaver use-luajit #{v} && luajit -v"
    end
  end
end
