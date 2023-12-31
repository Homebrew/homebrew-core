class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.80/putty-0.80.tar.gz"
  sha256 "2013c83a721b1753529e9090f7c3830e8fe4c80a070ccce764539badb3f67081"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f29412db90b14f856819ff9918edfc115d3bd06dc88813889e31479433757f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d9fd0b838264122474db95895ee3bdbc5c7e2759e60e46609698fc513bf6a7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "615cbf976762644da1935ec6e5cf74cea68b9bf50ac6012c7fbca902f612558d"
    sha256 cellar: :any_skip_relocation, sonoma:         "433e774292e163a92035d870739f0cb93f519d39ad426a124a16c10dc501a1d4"
    sha256 cellar: :any_skip_relocation, ventura:        "2a8c2a1ad499c1506fdd9dd675250d5921cba6e619d4bb18701a0580c1aecb7c"
    sha256 cellar: :any_skip_relocation, monterey:       "fae6932baeac85c3d67862eb734b3e92bbca8a89944af90e238f30688c3aa1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71179d8b7696e8c98931825c9ceb8e03b9ee36dc792797b92140c94c738eab04"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "perl" => :build
  uses_from_macos "expect" => :test

  conflicts_with "pssh", because: "both install `pscp` binaries"

  def install
    build_version = build.head? ? "svn-#{version}" : version

    args = std_cmake_args + %W[
      -DRELEASE=#{build_version}
      -DPUTTY_GTK_VERSION=NONE
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"command.sh").write <<~EOS
      #!/usr/bin/env expect
      set timeout -1
      spawn #{bin}/puttygen -t rsa -b 4096 -q -o test.key
      expect -exact "Enter passphrase to save key: "
      send -- "Homebrew\n"
      expect -exact "\r
      Re-enter passphrase to verify: "
      send -- "Homebrew\n"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system "./command.sh"
    assert_predicate testpath/"test.key", :exist?
  end
end
