class Gocryptfs < Formula
  desc "Encrypted overlay filesystem written in Go"
  homepage "https://nuetzlich.net/gocryptfs/"
  url "https://github.com/rfjakob/gocryptfs/releases/download/v2.2.1/gocryptfs_v2.2.1_src-deps.tar.gz"
  sha256 "8d3f66fe426de6b31dfd56122f26047cc8cda679d2fba7bc26d78448701da5e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "547ae8e3dc0e26664d9fa02462f49956c8da5fa38bbaf3aa61f1da2fe5014194"
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
