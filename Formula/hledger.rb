class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.20/hledger-1.20.tar.gz"
  sha256 "6096ac52c07e40461166efe86e0b888ebd5ca88f01c172bdcfbd18697fc9254a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ea0f380189028b5e6f1c41743de1692553d7752a001ea0f7e3ba715ba5d31d8e" => :catalina
    sha256 "db03cb4f2d644d7fd090898d039bb4ca5509ced2f116ecd1f2950bd077864098" => :mojave
    sha256 "31d4beba55f2acbe521b255b40e9751cba33065193be8be102381cfffcc98f62" => :high_sierra
  end

  depends_on "ghc@8.8" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.20/hledger-lib-1.20.tar.gz"
    sha256 "6d092f0224c4c188583c17890d8ce15ce04760324a088f24d8ccbe8b5c4088f4"
  end
  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.20/hledger-ui-1.20.tar.gz"
    sha256 "b8521b20240095781fecbb82957d0aef81c0381f58a2dd6f64e20abd2bc8dd4d"
  end
  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.20/hledger-web-1.20.tar.gz"
    sha256 "e365664602b4af455078d4ff0f74e084349ee5b80113477450ba6e71d2fc5b21"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      system "stack", "init", "--resolver=lts-16.12"
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}"

      man1.install "hledger-1.20/hledger.1"
      man1.install "hledger-ui/hledger-ui.1"
      man1.install "hledger-web/hledger-web.1"
      man5.install "hledger-lib/hledger_csv.5"
      man5.install "hledger-lib/hledger_journal.5"
      man5.install "hledger-lib/hledger_timeclock.5"
      man5.install "hledger-lib/hledger_timedot.5"

      info.install "hledger-1.20/hledger.info"
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
