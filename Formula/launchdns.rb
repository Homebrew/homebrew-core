class Launchdns < Formula
  desc "Mini DNS server designed solely to route queries to localhost"
  homepage "https://github.com/josh/launchdns"
  url "https://github.com/josh/launchdns/archive/v1.0.4.tar.gz"
  sha256 "60f6010659407e3d148c021c88e1c1ce0924de320e99a5c58b21c8aece3888aa"
  license "MIT"
  revision 2
  head "https://github.com/josh/launchdns.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76976e31629220e8697a50b0e52d080cef29a6b761a987175b07438d35225ff8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b7e3e37f394c83c8957c6c2253260805a3abcbb843890c90208d7d743da3328"
    sha256 cellar: :any_skip_relocation, monterey:       "7883b009f177ae1ede81bc9d27706e26fc8d8bde4cd3e1c45c5cd8f4021cbafd"
    sha256 cellar: :any_skip_relocation, big_sur:        "87785cae4d4966c318e8fb8424749261b16bb543576e1c45d5fa2bae7f4c3f0e"
    sha256 cellar: :any_skip_relocation, catalina:       "ebae3446c46a7a6662c3e9b95d61bbee372f1f277a07a4beea1eafc00d64570a"
    sha256 cellar: :any_skip_relocation, mojave:         "38ad8be46847983774ec6b50896560517bb027b6fe5e5543395f168e489c9c27"
  end

  depends_on :macos # uses launchd, a component of macOS

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "--with-launch-h", "--with-launch-h-activate-socket"
    system "make", "install"

    (prefix/"etc/resolver/localhost").write <<~EOS
      nameserver 127.0.0.1
      port 55353
    EOS
  end

  service do
    run [opt_bin/"launchdns", "--socket=Listeners", "--timeout=30"]
    error_log_path var/"log/launchdns.log"
    log_path var/"log/launchdns.log"
    sockets "tcp://127.0.0.1:55353"
  end

  test do
    output = shell_output("#{bin}/launchdns --version")
    refute_match(/without socket activation/, output)
    system bin/"launchdns", "-p0", "-t1"
  end
end
