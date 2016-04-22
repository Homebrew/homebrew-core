class Cadubi < Formula
  desc "Creative ASCII drawing utility"
  homepage "https://github.com/statico/cadubi/"
  url "https://github.com/statico/cadubi/archive/v1.3.1.tar.gz"
  sha256 "162c3ba748bbd2ab1699c95d4ad0e257ffe183959e6ce084ab91efbd3eb73f8a"

  bottle :unneeded

  def install
    inreplace "cadubi", "$Bin/help.txt", "#{doc}/help.txt"
    bin.install "cadubi"
    doc.install "help.txt"
    man1.install "cadubi.1"
  end

  # Fix incompatibilities with perl 5.22
  patch do
    url "https://github.com/statico/cadubi/commit/f079b6eb666d9930abad825ee5c0720415a93b9e.patch"
    sha256 "95c54ddc6f35a37cb09fa661da2de29c4346aebf6944b15a8e8a27ecf7a4ceb5"
  end

  test do
    output = shell_output("script -q /dev/null #{bin}/cadubi -v | cat")
    assert_match "cadubi (Creative ASCII Drawing Utility By Ian) #{version}\r\nCopyright (c) 2015 Ian Langworth", output # complete match because we are not checking the exit code
  end
end
