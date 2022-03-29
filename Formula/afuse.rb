class Afuse < Formula
  desc "Automounting file system implemented in userspace with FUSE"
  homepage "https://github.com/pcarrier/afuse/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/afuse/afuse-0.4.1.tar.gz"
  sha256 "c6e0555a65d42d3782e0734198bbebd22486386e29cb00047bc43c3eb726dca8"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 catalina:     "cf5a7aeba0e2504ea5bf7bf691ed2d0f8245cbac069b089359588e7df04140e0"
    sha256 cellar: :any,                 mojave:       "d28d229c3bc7317681e538388a3d87df170aa56dc8e5e9ced6bf964e6fafba71"
    sha256 cellar: :any,                 high_sierra:  "5596df8a8351206809f4b047e9d357e36273f5d505e531db3f14d320cf7eec28"
    sha256 cellar: :any,                 sierra:       "900e55a47834181f518e87e7cbaaf0f3f078b0d40631ffccfc776e82c7c61f87"
    sha256 cellar: :any,                 el_capitan:   "a4c0f86a179ca8c5d1e3977ff167dbcd1abff4ec1ee17fd5700a3fb602c781a3"
    sha256 cellar: :any,                 yosemite:     "2a57c7752c7b461f6b628a1c30e845fe13685eab394d933e8da3aebf7102ae9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4bd4dbb3bcc5634a41c6f6332e6f77dbb4404fc7545d53479e309a77613f17ad"
  end

  depends_on "pkg-config" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
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
    expected = if OS.mac?
      "OSXFUSE"
    else
      "FUSE library version"
    end
    assert_match expected, pipe_output("#{bin}/afuse --version 2>&1")
  end
end
