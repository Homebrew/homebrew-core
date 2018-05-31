class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.4.0.tar.gz"
  sha256 "137cd95dba78fa33475c26de59e226c4c9296ec5a752e629229bd2b183665e45"

  bottle do
    sha256 "02e24b89b950892f6fa7abda489a5232144fb78d7da88c6c6ba17d1724fdde89" => :high_sierra
    sha256 "4781f4b8a80c3588a4bb18d293f7b59699049c028fc962cb69ebc941951f172d" => :sierra
    sha256 "7bec128188eff3d5f74d5d019f3b752f1ce22b0db8efed0401db3624657f1a73" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
