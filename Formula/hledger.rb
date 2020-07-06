class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.18.1/hledger-1.18.1.tar.gz"
  sha256 "0c88c9a1896a6c431854c76229f0fe8d9bc59b6560829a4af1b8fcbad85486fa"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3a0849f59d9db817166c2d029d5ea25d9a95d62f8a9b4f9db2bda443d4d2aaa" => :catalina
    sha256 "64cda6dc29ef5bc5fe65f6c3669a1738076849798a030bc8819166001b13ec62" => :mojave
    sha256 "702f4abb102cb59528c4f33a6d6a6aa48c7a12cf0db0008e493cef429e62060a" => :high_sierra
  end

  depends_on "ghc@8.8" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.18.1/hledger-lib-1.18.1.tar.gz"
    sha256 "44c265b655a8ad37111821d58486bdbe7e8f0e285d3ecb94b46d132b0219cd99"
  end
  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.18.1/hledger-ui-1.18.1.tar.gz"
    sha256 "c4f487ea97ac83ac5f2efd772f24e70b47339ba6ebdb3fbfb4f693e046faee3d"
  end
  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.18.1/hledger-web-1.18.1.tar.gz"
    sha256 "3e2ca18e5a5d0c76c19208ede84b3931844254382c9f9a48a2fd1c8da3ef20e8"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      system "stack", "init", "--resolver=lts-15.16"
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}"

      man1.install "hledger-1.18.1/hledger.1"
      man1.install "hledger-ui/hledger-ui.1"
      man1.install "hledger-web/hledger-web.1"
      man5.install "hledger-lib/hledger_csv.5"
      man5.install "hledger-lib/hledger_journal.5"
      man5.install "hledger-lib/hledger_timeclock.5"
      man5.install "hledger-lib/hledger_timedot.5"

      info.install "hledger-1.18.1/hledger.info"
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
