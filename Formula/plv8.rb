class Plv8 < Formula
  desc "V8 Engine Javascript Procedural Language add-on for PostgreSQL"
  homepage "https://plv8.github.io/"
  url "https://github.com/plv8/plv8/archive/v2.3.3.tar.gz"
  sha256 "970cf775654f232a6b661683bb6c5f53d9f6c429fd23d3baa5f48624ac253fe0"

  depends_on "postgresql"
  depends_on "python@2"

  def install
    system "make"
    system "make", "install"
  end

  test do
    ENV.prepend "PATH", Formula["postgresql"].bin, ":"
    system "make", "installcheck"
  end
end
