class EchoprintCodegen < Formula
  desc "Codegen for Echoprint"
  homepage "https://github.com/spotify/echoprint-codegen"
  url "https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz"
  sha256 "dc80133839195838975757c5f6cada01d8e09d0aac622a8a4aa23755a5a9ae6d"
  license "MIT"
  revision 2
  head "https://github.com/echonest/echoprint-codegen.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1c621c7cbf6b05aefa9d022bf8e59afe30a2890af8789f0b06ce693998f8b605" => :catalina
    sha256 "3bc7594efc0e206f367e80a7168962e97d6b4b38b3bbaa3425dd9e2c65450b93" => :mojave
    sha256 "d23aa4f269c7c0f526363243a437b54bdc7331735a0e20b3846a6ebddf7d23a0" => :high_sierra
    sha256 "1c071bc8bcbb1a74f0930c07f2d11058d86b8d2f576b262eaaa7a79af0a5dfd3" => :sierra
    sha256 "06f93b8c6bb025d833ff7757048ea0680b240e3cdd6a51f4dd2fb4e6aad3f7dd" => :el_capitan
  end

  depends_on "boost"
  depends_on "ffmpeg"
  depends_on "taglib"

  # Removes unnecessary -framework vecLib; can be removed in the next release
  patch do
    url "https://github.com/echonest/echoprint-codegen/commit/5ac72c40ae920f507f3f4da8b8875533bccf5e02.diff?full_index=1"
    sha256 "713bffc8a02e2f53c7a0479f7efb6df732346f20cb055a4fda67da043bcf1c12"
  end

  def install
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
  end
end
