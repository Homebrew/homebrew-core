class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.78/putty-0.78.tar.gz"
  sha256 "274e01bcac6bd155dfd647b2f18f791b4b17ff313753aa919fcae2e32d34614f"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73d76e3809e293c8a1822f810831234d5a428d8d0574f043d4394ea0ae22e4f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98350a82ed60a6d22d3ef1fad8dc3a5e2ce8d44f2fea51d6f853315fed7b2a9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e6964cbe0895d4f3b6c832062c0bcb8654264115fc522d2cbb7f17932e37117"
    sha256 cellar: :any_skip_relocation, ventura:        "171f040dd0cf286f69836bf1c17a6fbc148bee5ef6392c328ac0731635a79115"
    sha256 cellar: :any_skip_relocation, monterey:       "ed3b2388437bbb394523ed1956cfbc6ab7283763b6c07edec255bb3e5d5d2496"
    sha256 cellar: :any_skip_relocation, big_sur:        "e84fd110e478867048f4f8a45c0b10e7f7414cb4a31f4e38ee46649e6ca9fdfb"
    sha256 cellar: :any_skip_relocation, catalina:       "35e0f3246651376a6c47765375faf56747ab81a8c03f4ffeb3c02429530e609d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51f654755b631cb5d5fedb590f2510e1e1f689444a9624fe39eef42173f2b76b"
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
