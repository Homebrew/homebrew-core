class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.19.4",
      revision: "61945c007df08af40b329baaad04c2b5b3e8a293"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "c4c91f43d9f6eb322155777b0a6f12ead207a4f557e668d32edd034ca710b494"
    sha256               arm64_tahoe:       "f5786b92c21a959f0ed743470e305d576ab850cdcdaa32c965fe754fdad8c5e6"
    sha256               arm64_sequoia:     "189d61bc888b3b46aa3e46cbe200303c5bcc28c940e87cfa124988381761d846"
    sha256 cellar: :any, arm64_linux:       "f2bdc99f4671cd10cbf54bf909dbd0782676cd1758dc57c5457cc3eff0932e02"
    sha256 cellar: :any, x86_64_linux:      "0b19ede8ffae996b7727dd29925fbe57c5223c2e7446224653604181578514ed"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = spawn bin/"dcd-server", "-p", port.to_s
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
