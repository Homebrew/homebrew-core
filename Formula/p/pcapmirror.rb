class Pcapmirror < Formula
  desc "Tool for capturing network traffic on remote host using TZSP or ERSPAN"
  homepage "https://git.freestone.net/cramer/pcapmirror"
  url "https://git.freestone.net/cramer/pcapmirror/-/archive/0.7.1/pcapmirror-0.7.1.tar.gz"
  sha256 "b01b56d8515dbcdfb93e48bae171770747ba4772997e388adfc43397ff553232"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77f47da4783e995fe6b2773ba2098655c2a440da28d5022f6c6a9243c65ac26c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab6d79df326037bb047fe8cfc6dc549cb747f0f7188d23f1949796d5f42a2e4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "771d61c56e1f6586f11cd438648d263170c45f210c11793f9ce35919204d4a60"
    sha256 cellar: :any,                 arm64_linux:       "e234a695b640d5949c8ba15c515041fb4756ea8d964b13aaca74e1a26fc5cccf"
    sha256 cellar: :any,                 x86_64_linux:      "98c43f5c76d5be2121a25ad07a33b55db98dbdb813c0f14e2f82188b7b5a40f4"
  end

  depends_on "make" => :build
  uses_from_macos "libpcap"

  on_linux do
    depends_on "libpcap"
  end

  def install
    bin.mkpath
    man8.mkpath
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
    assert_match "Available network interfaces:", shell_output("#{bin}/pcapmirror -l")
  end
end
