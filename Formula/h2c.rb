class H2c < Formula
  desc "Headers 2 curl"
  homepage "https://curl.se/h2c/"
  url "https://github.com/curl/h2c/archive/fee2a0361b4124dbd5565cee2a90ffb0c80ab7b0.tar.gz"
  sha256 "8eba84aef62506dfff4f0d975a062fa5f347c3298784c8f4f778a0244fec4df0"
  license "MIT"

  def install
    bin.install "h2c"
  end

  test do
    assert_match "h2c.pl [options] < file", shell_output("h2c --help")

    # test if h2c can convert HTTP headers to curl options.
    assert_match "curl --head --http1.1 --header Accept: --header \"Shoesize: 12\" --user-agent \"moo\" https://curl.haxx.se/", shell_output("echo 'HEAD  / HTTP/1.1\nHost: curl.haxx.se\nUser-Agent: moo\nShoesize: 12' | h2c")
  end
end
