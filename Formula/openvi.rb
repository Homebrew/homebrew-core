class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.2.20.tar.gz"
  sha256 "9bb7538f7381fd2d2bdc574f98bb154052b302200b1976203714086b007bf511"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e8a32ef6ed2b1e67143ce802e2152190f80be6591975e34d40323b8cae4c59a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3e177336337f5ea2b06512b5f7a71c2fefa18054f5f6cac8d649eaf436bac05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01764787b55f544f29951dbf49c6e829d8373f18ea4d972e8e7296efe1253743"
    sha256 cellar: :any_skip_relocation, ventura:        "2c88aabb9af3580bdb5facc97865ae3ba1fd5507991fda6004bf32ea0ba6284b"
    sha256 cellar: :any_skip_relocation, monterey:       "4de9abcd76e3672517ac2d45d5ec1295721aff25d56dded5dd6c4283f89d9347"
    sha256 cellar: :any_skip_relocation, big_sur:        "187305db2e429b8c6ff5e2dbf9b4c782f8e9bdfa1b5194f9136ebe14847629f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbdd557e331a8e147b55c118c74ab0b658e2963a328265c4ed7856dc65b67b8a"
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
