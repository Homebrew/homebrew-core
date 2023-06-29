class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.4.23.tar.gz"
  sha256 "e353af0ea205663615218a02ac00520187dbb318205c209099027ce3b031fb0d"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dee0f438baa589b870f835bdd75eaf6b9257aa2ef30725e2cef8c71f12b6615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0466ec6437bebce248887ccd3a72ca4343b54a0e24a1c60fc5a6198d34c1966d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41dcffe9d674b6c732293dfdac0817871be051184bd00fb172ffb9d5a2bf0e42"
    sha256 cellar: :any_skip_relocation, ventura:        "9c124f91f9ac6d92154854ae7a087233df7d02a2459a9034e18b1237c622dca0"
    sha256 cellar: :any_skip_relocation, monterey:       "269de18f8bee34291a163b99e2ac75553a953ebf407191975dddb9ba5012eea7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef7c6f3a461db3807def434674d50ac2195cdac5c9801207b3d98f739e48b807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3c5b273272ec792fea27d045eb6b3378fef584f285c80c64b365bcc9f3c2c01"
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
