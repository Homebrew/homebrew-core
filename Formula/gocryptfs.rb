class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.0.1/gocryptfs_v2.0.1_src-deps.tar.gz"
  sha256 "31be3f3a9400bd5eb8a4d5f86f7aee52a488207e12d312f2601ae08e7e26dd02"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 catalina:     "adf2a34cc99f353992e790c856971e9128d55caf5c51a2ae0a50ff5506e63c1c"
    sha256 cellar: :any,                 mojave:       "3e4cd09514efbd074f41f6636f0df0b01708856446c1da1d6cfe766cd8cae121"
    sha256 cellar: :any,                 high_sierra:  "a7e6b3d28c3e3cd78ff4be78adc8d2feeb8061c7459d2c8e6f04e61f0029bb51"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17f830744e3b27561ba9808dd7842d6e6d7a575c95146e4cc413de48c42c173a"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    system "./build.bash"
    bin.install "gocryptfs"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    (testpath/"encdir").mkpath
    pipe_output("#{bin}/gocryptfs -init #{testpath}/encdir", "password", 0)
    assert_predicate testpath/"encdir/gocryptfs.conf", :exist?
  end
end
