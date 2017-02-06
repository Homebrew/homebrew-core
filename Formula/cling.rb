class Cling < Formula
  desc "interactive C++ interpreter"
  homepage "https://cdn.rawgit.com/root-mirror/cling/master/www/index.html"
  url "https://github.com/vgvassilev/llvm.git", :using => :git, :tag => "cling-patches-r274612", :revision => "bc990e2aa9448cfea850efc31fda4201718f4e0f"
  version "0.3"
  sha256 "9776ad00bf1ecd7510ff06960de62a61cbafec1bde1a61177cb40d24110ed02d"

  depends_on "cmake" => :build

  resource "cling" do
    url "https://github.com/vgvassilev/cling.git", :using => :git, :revision => "efd446871cfb077189bf3df7fbbad58de51ff7fa"
    sha256 "ea59f541b46cd4525eab9220c84de8a2299ef7ca9078de267e7cdc7e395ccbc4"
  end

  resource "clang" do
    url "https://github.com/vgvassilev/clang.git", :using => :git, :tag => "cling-patches-r274612", :revision => "1d3611b352ada6e8fc8dd41631bd17495f37b258"
    sha256 "17f60d37e62c7cecdded476a08e9483dedf16a681bb0f8eac225013dc016287b"
  end

  def install
    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/cling").install resource("cling")

    mktemp do
      system "cmake", "-G", "Unix Makefiles", buildpath, *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/cling '#include <stdio.h>' 'printf(\"Hello World!\n\")'"
  end
end
