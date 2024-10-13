class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.81/putty-0.81.tar.gz"
  sha256 "cb8b00a94f453494e345a3df281d7a3ed26bb0dd7e36264f145206f8857639fe"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d4f1ebec6dc4712148681ee0322d1f0af99a0363e7807536470721c736754b94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8323405dffcac446d027bee3e03848ce07d8c3d4a8f626eaa302cae659d78772"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "171c6e16fc9c4157a5f43da3de8af558349393ad80b51e78b583c6ac233c08d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a3efb18c58c42f7c45e1432fef59dc26f3ff653b65d8b21c4f5a4524343f11d"
    sha256 cellar: :any_skip_relocation, sonoma:         "983b30ce0c3ca5e6059fabfa1a5a4855e82f527d13f483c6bba45c8e005b4366"
    sha256 cellar: :any_skip_relocation, ventura:        "4805d14b128dc36bc2118d66e0f0a648709ae1c5561270b5901bda70f22a2378"
    sha256 cellar: :any_skip_relocation, monterey:       "bc85f8be2bcbc40c7b322813c4a841d85762a69888bc55d2ee32b6c2a7c8535c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c346418520e243b63a68a70c53392cbc3a7a9503bb3e2d494b41d4ff035f6f4"
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
