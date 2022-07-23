class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.1.18.tar.gz"
  sha256 "39c4ac933f52c65021be06fcece8bfd308fc1ac08e8ff4604b2fdd1994192d08"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f611f0b540acbf421d2974ee16160abae040d936ac4967a35ea43927b4420cb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63752e1d0c23b9a02a2a9587bc5a9c0a22f2883b95ea2b5039119b9de33b04d1"
    sha256 cellar: :any_skip_relocation, monterey:       "b79c000683e5bc7e3279b185f018299e5568d2e79c31000d3607f68e2bc52777"
    sha256 cellar: :any_skip_relocation, big_sur:        "93be6c7314fccb3ff9e9a77b7b06af9adcef66a4ec33d440953b74288511ff25"
    sha256 cellar: :any_skip_relocation, catalina:       "d6073577026b5c8421ccda24d9a6b87dc176795cf7a9631151c2b5114d70e36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8132b1ccd79a17fd5d539c78cca430af927f5f0a3b60f3d89ca91f0b215e018f"
  end

  uses_from_macos "ncurses"

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
