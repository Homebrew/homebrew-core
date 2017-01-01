class Luaver < Formula
  desc "Manage and switch between versions of Lua, LuaJIT, and Luarocks"
  homepage "https://github.com/DhavalKapil/luaver"
  head "https://github.com/DhavalKapil/luaver.git"

  stable do
    url "https://github.com/DhavalKapil/luaver/archive/v1.0.0.tar.gz"
    sha256 "5c7eb65ea9b3cb4f10987c1d564e6e86bd6ad4f9d829a799121c83f0d85bd390"

    patch do
      url "https://github.com/DhavalKapil/luaver/pull/9.patch"
      sha256 "390929ef53b6e8e372451049eeffbfa51b9e31d7071e386478b871a835aba2db"
    end
  end

  bottle :unneeded

  depends_on "wget" => :run

  def install
    bin.install "luaver"
  end

  def caveats; <<-EOS.undent
    Add the following at the end of the correct file yourself:
      if which luaver > /dev/null; then . `which luaver`; fi
    EOS
  end

  test do
    lua_versions = %w[5.3.3 5.2.4 5.1.5]
    lua_versions.each do |v|
      ENV.deparallelize { system ". #{bin}/luaver && luaver install #{v} < /dev/null" }
      system ". #{bin}/luaver && luaver use #{v} && lua -v"
    end
    luajit_versions = %w[2.0.4]
    luajit_versions.each do |v|
      system ". #{bin}/luaver && luaver install-luajit #{v} < /dev/null"
      system ". #{bin}/luaver && luaver use-luajit #{v} && luajit -v"
    end
  end
end
