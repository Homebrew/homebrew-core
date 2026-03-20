class Ngrep < Formula
  desc "Network grep"
  homepage "https://github.com/jpr5/ngrep"
  url "https://github.com/jpr5/ngrep/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "6c94b31681316b7469a3ace92d2aeec7c9f490bd6782453dff2ade0e289a3348"
  license "ngrep"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1487edf4329ee5db9a24d68a11f644e1e813d30ca8605ac62d0a057a019e21f4"
    sha256 cellar: :any,                 arm64_sequoia: "c7d7984b630b7d3195393fa8a167ae17cab51ecc52b09ef3e9eb48c2374f35ff"
    sha256 cellar: :any,                 arm64_sonoma:  "571db700b3f2abb8ae566501b475c9ce507b1c55b907521b8a6435c99a54ea03"
    sha256 cellar: :any,                 sonoma:        "9247b2f48f87ec9544f2aa61a8f2cffe7e7f752264a4e308a07484de87bb030c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ac563e0d84b7ced1dc23ca7457c468fdb06577018234cdf97a08fb3c192cc59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d1bdb62dc7b2a9310d448702b8f2ee1e8e58661ea05d65dbae7972a4f1ff4b3"
  end

  depends_on "libpcap"
  depends_on "pcre2"

  def install
    args = %w[
      --enable-ipv6
      --enable-pcre2
    ]
    args << "--with-pcap-includes=#{Formula["libpcap"].opt_include}"

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngrep -V")
  end
end
