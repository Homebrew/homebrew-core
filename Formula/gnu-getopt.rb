class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.1.tar.xz"
  sha256 "09fac242172cd8ec27f0739d8d192402c69417617091d8c6e974841568f37eed"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a9e3eed0d4d9dd91a6a87f4faccad9a2a653581b119fa8cfb637efbb0f5f260" => :big_sur
    sha256 "191033a9ec2018a50c11257c78d9f30f58b1e5a5d9a1d0366374840c5c948db7" => :arm64_big_sur
    sha256 "5b79b3c5e0792ef471e8a45e7be1c6b53cfc82b06dc702269404bc2105c801e1" => :catalina
    sha256 "be850eb3ab001ca8ef8f34fbe7fed93b784462a9b88c68011854a977cf492b06" => :mojave
    sha256 "94ec5fdb67ca588ae797498c9a3a5b53aa8fea773cb6350d0d611f1248ab693a" => :high_sierra
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
