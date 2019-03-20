class Lux < Formula
  desc "Test automation framework with Expect style execution of commands"
  homepage "https://github.com/hawk/lux"
  url "https://github.com/hawk/lux/archive/lux-2.0.2.tar.gz"
  sha256 "9fddc54d6999ae4bf9180df514b65fda998c39a5bad3de4386d3ae834a0b9f23"

  head "https://github.com/hawk/lux.git", :branch => "develop"

  depends_on "autoconf" => :build
  depends_on "erlang"

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
   (testpath/"test.lux").write <<~EOS
    [doc Simple test]
    [shell myshell]
        !echo foo
        ?echo foo
        ?^foo
    EOS

    output = shell_output("lux test.lux")
    assert_match "SUCCESS", output
  end
end
