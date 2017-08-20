class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.17.06.14.tar.gz"
  sha256 "6179a92bbe1893b7c5b1dff7c8eaba277c194870d17039addf2d389cbb68b87e"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd1d8550bf408973489576ba1f0f157cf24db831001fd4b0d9ee7293f5e3c337" => :sierra
    sha256 "93ecac6ad4eea1c8931a17c5c2b1d30b5b8cc0fe60c8f8e24519b2e4c539b586" => :el_capitan
    sha256 "d53e4ed5eee656a9edccea69afacd9db0059621a355138a1f4fb3b705611e062" => :yosemite
  end

  def install
    system "make"

    # No "make install" https://github.com/Oblomov/clinfo/issues/23
    bin.install "clinfo"
    man1.install "man/clinfo.1"
  end

  test do
    assert_match /Device Type +CPU/, shell_output(bin/"clinfo")
  end
end
