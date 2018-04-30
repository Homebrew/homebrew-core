class Plv8 < Formula
  desc " V8 Engine Javascript Procedural Language add-on for PostgreSQL"
  homepage "https://plv8.github.io/"
  url "https://github.com/plv8/plv8/archive/v2.3.3.zip"
  sha256 "324660045f838c549b5244d8c7dea84612430b12e00bf3a8a61fb500a9954de8"

  depends_on "postgresql"
  depends_on "python@2"

  def install
    system 'pg_config' # ensure postgres installed
    system "make"
    system "make install"
  end

  test do
    ENV.prepend 'PATH', Formula.factory('postgresql').bin, ':'
    system "make installcheck"
  end
end
