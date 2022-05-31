class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.77/putty-0.77.tar.gz"
  sha256 "419a76f45238fd45f2c76b42438993056e74fa78374f136052aaa843085beae5"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4ca114d39cb55f75ef0b71f496bb96acf2e3f97e10e66d3ea7de8a4c87dc51b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adb57691d42b70e51a4336dc37126996c782f2bf66db5d0f05813ebd04178ebf"
    sha256 cellar: :any_skip_relocation, monterey:       "ab3cc934eace1bfe68e8a8896888b1c1213a68d18c4591f59df3f9312e9fbb0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "75e23ad8100002d5ade0acf3745f4f40a9add28a25ea4814caafd0cb37be7cb8"
    sha256 cellar: :any_skip_relocation, catalina:       "ab58a1de02894bd5364c31e4a5b864acb81cbc0160814d048f98077bfe01a4b1"
    sha256 cellar: :any_skip_relocation, mojave:         "4aab22d3d6867678be1d1be95edb5fe41fcd7d807892b00b83d0280b6f356f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51689b0cb6c740349175dad1786ac7786b639e78f5e5b3765272ae83162009d4"
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
