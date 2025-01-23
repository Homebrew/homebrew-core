class Ne < Formula
  desc "Text editor based on the POSIX standard"
  homepage "https://github.com/vigna/ne"
  url "https://github.com/vigna/ne/archive/refs/tags/3.3.3.tar.gz"
  sha256 "4f7509bb552e10348f9599f39856c8b7a2a74ea54c980dd2c9e15be212a1a6f0"
  license "GPL-3.0-only"
  head "https://github.com/vigna/ne.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "dafb83eb90692275294db01e301fbfc9548d2a6f35da5072c292f03d48700617"
    sha256 arm64_sonoma:   "8a550b3330062f58387f3addb83b6c8c31a16fb7e41f14486430c61deee7fd91"
    sha256 arm64_ventura:  "28a91f4763d506a1e7e9bacb1c269e1dfff9f7398004787e1b463d2642cf182c"
    sha256 arm64_monterey: "8091c957dc10498784eeac265ec6d9abdd44ae8bc877a9deedb57a639c4bd310"
    sha256 sonoma:         "570cd0bc07142caee0a19dd6102d70c7320a7d449b4c7ee440e5515b1de6d731"
    sha256 ventura:        "fe7942bde38c0379cc080eba7f19a8efdc687297ba25a1b4bf698127025c9f7c"
    sha256 monterey:       "ce6c2287f4696841f25219e95282e497ed58b69435addca082756907838fdd8f"
    sha256 x86_64_linux:   "8acf0230899e5a22ccc93d0e48d582545b76d7f86d199b78a543c7949ddb0ab6"
  end

  depends_on "texinfo" => :build

  uses_from_macos "ncurses"

  on_linux do
    # The version of `env` in CI is too old, so we need to use brewed coreutils.
    depends_on "coreutils" => :build
  end

  def install
    # Use newer env on Linux that supports -S option.
    unless OS.mac?
      inreplace "version.pl",
                "/usr/bin/env",
                Formula["coreutils"].libexec/"gnubin/env"
    end
    ENV.deparallelize
    cd "src" do
      system "make"
    end
    system "make", "build", "PREFIX=#{prefix}", "install"
  end

  test do
    require "pty"

    ENV["TERM"] = "xterm"
    document = testpath/"test.txt"
    macros = testpath/"macros"
    document.write <<~EOS
      This is a test document.
    EOS
    macros.write <<~EOS
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    PTY.spawn(bin/"ne", "--macro", macros, document) do |_r, _w, pid|
      sleep 1
      Process.kill "KILL", pid
    end
    assert_equal <<~EOS, document.read
      This is a test document.
      line 2
    EOS
  end
end
