class Jsonpp < Formula
  desc "Command-line JSON pretty-printer"
  homepage "https://jmhodges.github.io/jsonpp/"
  url "https://github.com/jmhodges/jsonpp/releases/download/1.3.0/jsonpp-1.3.0-osx-x86_64.zip"
  version "1.3.0"
  sha256 "7e2461a985091cd62c7c64fe48fce24c50b829641125b024e1910538c1c431d4"

  bottle :unneeded

  def install
    bin.install "jsonpp"
  end

  test do
    expected = <<~EOS.chomp
      {
        "foo": "bar",
        "baz": "qux"
      }
    EOS
    assert_equal expected, pipe_output(bin/"jsonpp", '{"foo":"bar","baz":"qux"}')
  end
end
