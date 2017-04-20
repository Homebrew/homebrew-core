class Luabridge < Formula
  desc "Lightweight, dependency-free library for binding Lua to C++"
  homepage "https://github.com/vinniefalco/LuaBridge"
  url "https://github.com/vinniefalco/LuaBridge/archive/master.tar.gz"
  version "1.0.2"
  sha256 "9cc5943b6fd9581744d37c19c65f3f825b5d6b4f88f402197cb27daa532099db"

  def install
    include.install Dir["Source/*"]
  end

  test do
    system "true"
  end
end
