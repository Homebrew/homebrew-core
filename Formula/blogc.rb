class Blogc < Formula
  desc "Static blog compiler"
  homepage "https://blogc.rgm.io"
  url "https://github.com/blogc/blogc/releases/download/v0.12.0/blogc-0.12.0.tar.bz2"
  sha256 "421474fa089024015f7dca77386c3ca360531ae4510ae50b4dc3446653a4edbe"

  def install
    system "./configure", "--enable-runserver",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "git", "clone", "https://github.com/blogc/blogc-example.git"
    system "#{bin}/blogc", "-t", "blogc-example/templates/main.tmpl", "blogc-example/content/post/post1.txt"
  end
end
