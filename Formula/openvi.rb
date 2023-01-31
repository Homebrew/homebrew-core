class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.2.21.tar.gz"
  sha256 "0200c1b8a83534a85d00d696c904aa9fe2c50e17dd75831e5d03c7b7b74a6f8b"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70571ffc3ed44b3d30a6928b7337050c605a5c2beccabb9396ee877aa67663c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9773bfd563c52530ffc0164786e2c05d21d969cfda66f9f2ea194edf6e7432f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebc64ca416204fc7f19db55549e0e6ee5260111e357dc93ecb516ae7b7fb8ca3"
    sha256 cellar: :any_skip_relocation, ventura:        "3ed023ea00001325542b85fa705a971fd14999ebf30a56b8d50b60e4e20126d4"
    sha256 cellar: :any_skip_relocation, monterey:       "413beab54bf3168bc4ba6e45516df45e462d3227a326506f444b45ed84486218"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1d6d01c0d2f3baff10b284441d5608fa2c3517b1efe96efc9f85f40ca903900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41f1f280b43bd507f2cc9bedd2b995e20c9075b86af3f2c1b0ce5868a44d54bc"
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
