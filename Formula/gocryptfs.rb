class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.0.1/gocryptfs_v2.0.1_src-deps.tar.gz"
  sha256 "31be3f3a9400bd5eb8a4d5f86f7aee52a488207e12d312f2601ae08e7e26dd02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "43d8cf09fcd4cb76ac51246225cd30c68ea4abe9c944843a9788534e09ea9e18"
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
