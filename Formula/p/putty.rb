class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.79/putty-0.79.tar.gz"
  sha256 "428cc8666fbb938ebf4ac9276341980dcd70de395b33164496cf7995ef0ef0d8"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea44fd2f1e5e45aeb12d4c1b1538ca7fb4c41524d05c6e0999070f5ff40fed98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fae9d89bbf462789f4146ea555e6384174fcb1d99cbeb3f66c6786299cb374c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d55a3b006c5854daf0ff821293458660fc298f9d72e7f7f0065fac637f7b19c1"
    sha256 cellar: :any_skip_relocation, ventura:        "aaae6300920f3da24bf2713ad8be57ae3f12b585d4b3f0499c3226a97c039455"
    sha256 cellar: :any_skip_relocation, monterey:       "470befc911fc9d3fb454efe342418fa6ed1dca736a498de0ae909a3faab0a79f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b35b6e0ca90d4aa5fea2e473e3c2f17be6f16b3edcc2cb1e037bc8c240bd2b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "782be1588c0add9ea780c3bf09106584bbef7402d0bc9aa449da3e25bb0b67f4"
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
