class Nvtop < Formula
  desc "Interactive GPU process monitor"
  homepage "https://github.com/Syllo/nvtop"
  url "https://github.com/Syllo/nvtop/archive/refs/tags/3.4.0.tar.gz"
  sha256 "7979f425dc2b748ff191e3999a0994af6154795e0e8640fae1e177684a296e08"
  license "GPL-3.0-or-later"

  bottle do
    manifest_sha256 "390be4e76c9c24ac5058a24584a8501c309ea867e3a36f6d8b78200f0dd63895"
    sha256 cellar: :any, arm64_golden_gate: "51f654b4dc7a59dea8752df811b77801eef3244d73faaa47ea6415bc187fe873"
    sha256 cellar: :any, arm64_tahoe:       "559c770e90849e10b207bb0cac9a4828f74b39115b607c54edd65073ccaed1dd"
    sha256 cellar: :any, arm64_sequoia:     "2573b08206524a93f5a56e9ab2c294e261c97fe09fed65992eface285dc7e1d3"
    sha256 cellar: :any, arm64_linux:       "043bf47ac3227153b7948e242b36f7ac70df5d6fbf09eb40c1edfe848dcab7f8"
    sha256 cellar: :any, x86_64_linux:      "bc3fcebf0604907b2908b5d7e91d0b30ae97509ea71bac433b1fd3753928a598"
  end

  depends_on "cmake" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libdrm"
    depends_on "systemd"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # nvtop is a TUI application
    assert_match version.to_s, shell_output("#{bin}/nvtop --version")
  end
end
