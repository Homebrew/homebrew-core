class Neo < Formula
  desc "Simulates the digital rain from \"The Matrix\""
  homepage "https://github.com/st3w/neo"
  url "https://github.com/st3w/neo/releases/download/v0.6.1/neo-0.6.1.tar.gz"
  sha256 "a55e4ed5efd0a4af248d16018a7aaad3b617ef1d3ac05d292a258a38aaf46a79"
  license "GPL-3.0-or-later"

  uses_from_macos "ncurses"

  def install
    ENV.append "LDFLAGS", "-lncurses"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match "Stewart Reive", shell_output("#{bin}/neo --version")
  end
end
