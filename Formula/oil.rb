class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.11.tar.gz"
  sha256 "0ae97bca30c8957156e77479132b954b63e1e47bfe284c628aa36ab01f66d089"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e47bb7ac29bd5bee2334a75e9b3b33e2a14f61540268498da543f9c0f2e2db26"
    sha256 big_sur:       "2e53867c72bca15e9ca9aca7abff90ce130842ae3ea351d38f93a088486537b4"
    sha256 catalina:      "2019afa3e50a5a2a83d8350c31a8c51eac3e40a12343e9ecf411e7198694920d"
    sha256 mojave:        "0b452d3ce2826a66f9143487bff4bbf9f88169538903c201c62b815c8fb7c162"
  end

  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -q parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
