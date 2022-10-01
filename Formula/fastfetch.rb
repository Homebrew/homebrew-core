class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.7.2.zip"
  sha256 "351996b962919c7fd7a2fb7f1d6daed19a4dc91ea2f0f1b486c831dae58f1145"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "libplist" => :build
  depends_on "vulkan-loader" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Install libplist for iTerm terminal font detection
    EOS
  end

  test do
    output = shell_output("#{bin}/fastfetch --list-features")
    assert_match "vulkan\n", output
  end
end
