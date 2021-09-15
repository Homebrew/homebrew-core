class EchoprintCodegen < Formula
  desc "Codegen for Echoprint"
  homepage "https://github.com/spotify/echoprint-codegen"
  url "https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz"
  sha256 "dc80133839195838975757c5f6cada01d8e09d0aac622a8a4aa23755a5a9ae6d"
  license "MIT"
  revision 2
  head "https://github.com/echonest/echoprint-codegen.git"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_big_sur: "45bd6c87a9d59b80d5912ea79dd62ea7f6367419529f2f4c93713ddc385a4b3b"
    sha256 cellar: :any,                 big_sur:       "de3efebbd14d58d2d98757f76e0a2f96f2fe9c29ee486f15aeaf0eac6a835a13"
    sha256 cellar: :any,                 catalina:      "5772abd774aa57f8584a46f0aad46d51f31196ff32e6e5e2601e4129002a40bc"
    sha256 cellar: :any,                 mojave:        "6c7203190f4d0a0e9d62a376fe60daa02ab17b7f0523db26979802719dae3ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ede691a8c9591206e178e97174fe8e647d428d6a6f208233396ec1a6c06ff41"
  end

  deprecate! date: "2021-02-09", because: :unmaintained

  depends_on "boost"
  depends_on "ffmpeg"
  depends_on "taglib"

  # Removes unnecessary -framework vecLib; can be removed in the next release
  patch do
    url "https://github.com/echonest/echoprint-codegen/commit/5ac72c40ae920f507f3f4da8b8875533bccf5e02.patch?full_index=1"
    sha256 "1c7ffdfa498bde0da8b1b20ace5c67238338648175a067f1b129d2c726ab0fd1"
  end

  def install
    # Further Makefile fixes for https://github.com/spotify/echoprint-codegen/issues/97#issuecomment-776068938
    inreplace "src/Makefile", "-lSystem", ""
    inreplace "src/Makefile", "-framework Accelerate", ""
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
  end
end
