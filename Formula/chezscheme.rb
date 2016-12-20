class Chezscheme < Formula
  desc "Chez Scheme"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/archive/v9.4.tar.gz"
  sha256 "9f4e6fe737300878c3c9ca6ed09ed97fc2edbf40e4cf37bd61f48a27f5adf952"

  depends_on :x11 => build

  conflicts_with "mit-scheme", :because => "both install `scheme` binaries"

  def install
    system "./configure", "--installprefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<-EOS.undent
      (display "Hello, World!") (newline)
    EOS

    expected = <<-EOS.undent
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/scheme --script hello.ss")
  end
end
