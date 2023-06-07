class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.dev/"
  url "https://github.com/nifty-site-manager/nsm/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "9e89a6cdfd65d8db582f5d6a60c7265db5fd67dc582ed24deaac4ccca8ca5737"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03670252b9a588208fe3548182f2b146abc37490f4a2a9a7adda4b0f32ccd7a9"
    sha256 cellar: :any,                 arm64_monterey: "4748104dbafa321de0ae87db393518c07a5f2137437a54ea166f7839724007f4"
    sha256 cellar: :any,                 arm64_big_sur:  "d4e79b6bff45450716498dad1a80d9dfafdbddfe9883735712a58b9f68538780"
    sha256 cellar: :any,                 ventura:        "6a43fdd81446c475588f957a7662c95ada67e98bb88662740364d63744ae7330"
    sha256 cellar: :any,                 monterey:       "de975fd25204c1a2dc45c9bb8af410512e26caddfa64104d54e7c0a31faabba4"
    sha256 cellar: :any,                 big_sur:        "8c7f81dcdd14387357e8b960426c41a847c23b66bcc3b0279baf29ae4bad6028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64b865e61959278aa2fc2fea67d3c8dea84c5f2ee44abd1532d4cc1ac8b979b3"
  end

  depends_on "luajit"

  # Fix build on Apple Silicon by removing -pagezero_size/-image_base flags.
  # TODO: Remove if upstream PR is merged and included in release.
  # PR ref: https://github.com/nifty-site-manager/nsm/pull/33
  patch do
    url "https://github.com/nifty-site-manager/nsm/commit/00b3ef1ea5ffe2dedc501f0603d16a9a4d57d395.patch?full_index=1"
    sha256 "c05f0381feef577c493d3b160fc964cee6aeb3a444bc6bde70fda4abc96be8bf"
  end

  def install
    inreplace "Lua.h", "/usr/local/include", Formula["luajit"].opt_include
    system "make", "BUNDLED=0", "LUAJIT_VERSION=2.1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
