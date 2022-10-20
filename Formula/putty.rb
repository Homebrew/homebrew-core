class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.77/putty-0.77.tar.gz"
  sha256 "419a76f45238fd45f2c76b42438993056e74fa78374f136052aaa843085beae5"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16327c91d5c76a3c249fe2efb6f6e3af697106bbc37ecc3a3bc4770145e450f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46e4e087744f4e4af5a5e451204b79adcff104131c6cf6c67dbe125c0858750b"
    sha256 cellar: :any_skip_relocation, monterey:       "c97140487bccfe8ad8ce35fc558853c9e6445e9cbc1f5468311f2a9561175bf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dc3675e19f89f21febb8a7a91c7dfa28bcbcad42528db1f20864dd8870b93e8"
    sha256 cellar: :any_skip_relocation, catalina:       "1aa26acec81e867eabb8e7efc35cdc68f3d7ee3395baccb104d566bd1d5d405d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df00c3b65018b7e6080871a2aed03bea797ea69df1a9d0cf92e8b40539367e9f"
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
