class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/en/index.html"
  url "https://github.com/xicilion/fibjs/releases/download/v0.2.1/fullsrc.zip"
  version "0.2.1"
  sha256 "914d79bb18e5309228747d73c481c1c243db8cc0ab1b29ec66f201cc2d8f85b9"

  head "https://github.com/xicilion/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88e3ab32d1beeff05ff560df3a801754497968d5be899fe1a5a9d09b91fb9ba1" => :sierra
    sha256 "ba281f85ad6e3b0ad65c47c25d8b3f3eda6a969f429735432a62451e024bab33" => :el_capitan
    sha256 "acb0013c7cf6d3f6dbf7793b5a3a1a627afd39af55c0b5e0cdf0b64da7eab9eb" => :yosemite
    sha256 "e08ec48ecb64a708f148d56e60f2b54d75629e3a9e0ee9bb88d8afa13a4964e4" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "./build", "release", "-j#{ENV.make_jobs}"
    bin.install "bin/Darwin_amd64_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end
