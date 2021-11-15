class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.37/util-linux-2.37.2.tar.xz"
  sha256 "6a0764c1aae7fb607ef8a6dd2c0f6c47d5e5fd27aa08820abaad9ec14e28e9d9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fe2a8f7dd7c5b369f4e8ffce9bbc4d3f3d1a83bdf7ecf592757e101b34c4023"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0accef38c1961b29622380bc5d3dc0a58b22158b510f6f39b72485da5cdfa7ae"
    sha256 cellar: :any_skip_relocation, monterey:       "8bfeedd0ff8fc2452342ff24841690eb5a733790cc86420eeea682760d69b2ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "71316eadcf6481acbbe020d23d51fbd0b004ed51b680c97b82a08fc11668d3d9"
    sha256 cellar: :any_skip_relocation, catalina:       "f6fa9b03686181c83f17936c1e9c5d5fa396ea8ca0b80ff82b1eb9ff64e224e2"
    sha256 cellar: :any_skip_relocation, mojave:         "75a567d2d0b9d1e4e8c7a385eb2205073918ef1b68fdea848e406be04c732580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcc3de837a5b93ff5c8ba2c5af599df827f2e00a0eab532c256f5fd346ed3b7a"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
