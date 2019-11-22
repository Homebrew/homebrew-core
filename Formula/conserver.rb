class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/conserver/conserver/releases/download/v8.2.4/conserver-8.2.4.tar.gz"
  sha256 "a591eabb4abb632322d2f3058a2f0bd6502754069a99a153efe2d6d05bd97f6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0543221000d5bc2022b45939bdad3b736931b3a5dc7e15c47a78d18e5cca2395" => :catalina
    sha256 "cc5c46b8adeeb4eb949f8abeedee67fce87dd1b17677622963619a496b511289" => :mojave
    sha256 "45f059778b3e32bb6cdcba3f52bb4ad99d3c2271ef0adfb61fc28a0299d3d8a2" => :high_sierra
    sha256 "972900dc19aeb2beb11371bc9dba0c241c842328dd573d449535529dc5f560ad" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
