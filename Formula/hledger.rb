class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.19.1/hledger-1.19.1.tar.gz"
  sha256 "d5c1eb6d8de5cf2d82771db1796b57a304095fa940773a6405c9cd8085f3da71"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "78527a945f1cbc65bbffeecd5d6c90459a87d8fc6e0b93732754708e4b3d6992" => :catalina
    sha256 "de845d3d884033a08f3da81e3ac2e19cc440bc85b20ee0a68d8b4b26cd590099" => :mojave
    sha256 "adaa414ea56dd3da220c2899c60e8d74f8efe470ca71d317f8d569ee8a0ff32c" => :high_sierra
  end

  depends_on "ghc@8.8" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.19.1/hledger-lib-1.19.1.tar.gz"
    sha256 "cabf263fe8a3c38822c9146b54a519fe56d369456c72be6db5a88c1c0208c15f"
  end
  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.19.1/hledger-ui-1.19.1.tar.gz"
    sha256 "d4154c33712b003dc15d795c92da59158d2ca5e02660234f731d2794a5403f9e"
  end
  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.19.1/hledger-web-1.19.1.tar.gz"
    sha256 "6085cb69bdc3808f929cc6ee621c0d3ffc773debe42bc1aaf0c7c1fe1a988a0f"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      system "stack", "init", "--resolver=lts-16.12"
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}"

      man1.install "hledger-1.19.1/hledger.1"
      man1.install "hledger-ui/hledger-ui.1"
      man1.install "hledger-web/hledger-web.1"
      man5.install "hledger-lib/hledger_csv.5"
      man5.install "hledger-lib/hledger_journal.5"
      man5.install "hledger-lib/hledger_timeclock.5"
      man5.install "hledger-lib/hledger_timedot.5"

      info.install "hledger-1.19.1/hledger.info"
      info.install "hledger-lib/hledger_csv.info"
      info.install "hledger-lib/hledger_journal.info"
      info.install "hledger-lib/hledger_timeclock.info"
      info.install "hledger-lib/hledger_timedot.info"
      info.install "hledger-ui/hledger-ui.info"
      info.install "hledger-web/hledger-web.info"
    end
  end

  test do
    system "#{bin}/hledger", "test"

    File.open(".hledger.journal", "w") do |f|
      f.write <<~EOS
        2020/1/1
          boat  123
          cash
      EOS
    end

    system "#{bin}/hledger-ui", "--version"

    pid = fork do
      exec "#{bin}/hledger-web", "--serve"
    end
    sleep 1
    begin
      assert_match /boat +123/, shell_output("curl -s http://127.0.0.1:5000/journal")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
