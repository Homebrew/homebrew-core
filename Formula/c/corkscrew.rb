class Corkscrew < Formula
  desc "Tunnel SSH through HTTP proxies"
  homepage "https://packages.debian.org/sid/corkscrew"
  url "https://deb.debian.org/debian/pool/main/c/corkscrew/corkscrew_2.0.orig.tar.gz"
  sha256 "0d0fcbb41cba4a81c4ab494459472086f377f9edb78a2e2238ed19b58956b0be"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/c/corkscrew/"
    regex(/href=.*?corkscrew[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ddf9f9bccfc3f8abdac5ab156b3adebb82d263eec75503ca53b657dba4e310f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d17faa8d3e8eb0fe11107515daf53fd0f9d22caaaa0d32993ca6e961ee9559cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f7a6be3731dfae7b92f6da9091b3e4665473c77b58c6f4d21d2cf6c6c511750"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bd52cc5c72e9ca3461dc63fdfb584ac3622a57effae88f14a8e7eab146a57b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1add42728d114c019b0621bbd8aa9f3f95c433e006f38bdba71d9387e667357"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7882ab8fa538eb9eee596f56fa6f65c14f1f3e467a822ce7a39ea197d2fe08a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "58a7a24041d6103063a3f4f8c96e1729afc175370aa27df66d0604a887fb61c3"
    sha256 cellar: :any_skip_relocation, ventura:        "16b81ff2ca5d308f0eb953399f4ec771870ff1019d93b69630f1218fbd185dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "51bb3c53d276f9abc51f7b6338ef96f3b2bd7686d8b331eb0ffdb52b51bdf9f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "af93a7005479f2004b385e484c633f42577d7cd99272d5e7ec4c17e3d0239a7b"
    sha256 cellar: :any_skip_relocation, catalina:       "83db433b1d34ad662d310504a476bcd5848955b0cc78087203b8e25164e4c8a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6961a98bcd314dd0590a00dcddf7101d673b5c6933b938b271e4f93a82d22c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aad5bc0cad7686b7741300366d92107ed90c84eabc8868d309a2f61c96b3135d"
  end

  depends_on "libtool" => :build

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    port = free_port

    fork do
      server = TCPServer.new port
      socket = server.accept
      Open3.popen3("#{bin}/corkscrew 127.0.0.1 #{port} www.google.com 80") do |_, stdout, _|
        socket.write "GET /index.html HTTP/1.1\r\n\r\n"
        assert_match "HTTP/1.1", stdout.gets("\r\n\r\n")
      end
    end
  end
end
