class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20260410.a852474.tar.gz"
  version "20260410"
  sha256 "0713f515794643d48c88e79429dc392741e2ae15093b8d92bfc189110228406a"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ipbt[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b4c3e90232369f35d47f594aa32973befe1aa273d6e86ab05ba9120db428e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e61b90b67295680942b77076e63e19c3898f83b4f20866069219e154636189bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbb93ec319c807cc8368a11896772edb3c3bd027e1bbfbbb210ed34ed7df1e4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "200a6fe42ba970e051837b39dcab5001ae37eacfb2fba47c6270ff29ebbffcb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "455ff4752bca6510113674292dc611f98acb179bb11c04389f4c03a1d4f4ae16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "162b9ca81927d323dca7c6c95181eef5b03f5dd01deba452ccde94fd16c38a54"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"ipbt"
  end
end
