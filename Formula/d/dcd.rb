class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.15.2",
      revision: "4946d49abdc35810254151923bab30fb3cc2c004"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e65b4d941203d3b3afbaa704b02d9180b5dc2d6f46f45fdd816a78ba5528418"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b667329fc26ff55eba9b62027200818deef9378c15f5524e0031f35d471bf9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1007cccd0a4c996e5a5515f978eefb67e57598d372ba7e43467d1c2220c80920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6ce58f93e86c4d23bbb23da6acb37c31d707cc2da062b9c541ff6ea65b303c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb5f1ff6bb06fc3ce9684604f04dc94e0f68a83df3ac59d6b511d923ae57746c"
    sha256 cellar: :any_skip_relocation, ventura:        "6c9cb410387c80d7d596bb925cf90cc0d1dfc8c0f9d3780b0ad1302540352265"
    sha256 cellar: :any_skip_relocation, monterey:       "70550825ebf34833947ca9e7bcb9ec03292d6ecbf77e6691d4791eaadc4218ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "5711120e29181ce752e1616c5777eea9864ac15d6583dc634aa3a9d9f47de647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "658abefb0b260e852fb16078e353b453929f6f04fa8af8f636ed2d5e2aa89fca"
  end

  on_macos do
    depends_on "ldc" => :build
  end

  on_linux do
    depends_on "dmd" => :build
  end

  def install
    target = OS.mac? ? "ldc" : "dmd"
    ENV.append "DFLAGS", "-fPIC" if OS.linux?
    system "make", target
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = fork do
      exec "#{bin}/dcd-server", "-p", port.to_s
    end
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system "#{bin}/dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
