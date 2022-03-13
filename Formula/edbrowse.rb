class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://www.edbrowse.org"
  url "https://github.com/CMB/edbrowse/archive/v3.8.2.1.tar.gz"
  sha256 "a9c1d1fd0665796b81f18b0556f80237c13594033062f9312a49aa9159086e7a"
  license all_of: ["GPL-2.0-only", "MIT"]
  head "https://github.com/CMB/edbrowse.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "pcre2"
  depends_on "readline"
  depends_on "tidy-html5"
  depends_on "unixodbc"
  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  resource "quickjs" do
    url "https://github.com/n0ot/quickjs-edbrowse/archive/7732911eedf406d2e0e4f6860c5d83050e3bbb33.tar.gz"
    sha256 "490bf0c5fb029bd3e2ca8265f5aa81ddfa466ba0066febdc3e0dcbac62878049"
  end

  def install
    resource("quickjs").stage do
      system "make"
      mkdir "#{buildpath}/quickjs"
      cp_r(".", "#{buildpath}/quickjs/")
    end

    Dir.chdir "src" do
      system "make", "QUICKJS_DIR=#{buildpath}/quickjs"
      system "make", "install", "PREFIX=#{prefix}"
    end

    prefix.install "CHANGES"
    prefix.install "COPYING"
    prefix.install "README"
  end

  test do
    require "open3"
    (testpath/".ebrc").write ""
    (testpath/"js.html").write <<~EOF
      <!DOCTYPE html>
      <script>
      alert("Hello, world!");
      </script>
    EOF

    Open3.popen3("#{bin}/edbrowse", "-d0", "-b", testpath/"js.html") do |stdin, stdout, _|
      stdin.write "q\n"
      stdin.close

      assert_equal "Hello, world!", stdout.read.strip
    end
  end
end
