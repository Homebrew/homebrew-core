class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.9.1.tar.gz"
  sha256 "876d9dd34e575c230fc63558e5974830b71a4c092a885526dfdbc19aba31c610"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "645483409ef5bcbe95ca15fa9010babeefa120136560dc3269d5506dcaebc17a"
    sha256 cellar: :any,                 arm64_monterey: "e7a9d5449a9f3540756842588180566cffe5e590a988e9e025fc4de9eaa232ca"
    sha256 cellar: :any,                 arm64_big_sur:  "2a4b61ff64d4d8bdaf725b76f84a0e9e630736be623dcd954952ef4799d2b56b"
    sha256 cellar: :any,                 ventura:        "fd5c644d12326c4875455cbe7351d7e246a2ca49bab20c7d2ee214aef09b11c8"
    sha256 cellar: :any,                 monterey:       "028ca91850653b792a6e856af4296e14519f80f3c4d7cee5d8fa8f00824cd148"
    sha256 cellar: :any,                 big_sur:        "0f6d8d0be8a041ad99134aa3892258448e48574fcc213c2dd7789fb4eac36843"
    sha256 cellar: :any,                 catalina:       "b6d68c912426c0535ddbb889d09132450576319f23dc67869f14c6ef9f2422e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "334fd7671f9e706fa037f0f9d500705a63261a22b9fe27062d7ad2507fbbec08"
  end

  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libxcb"

  def install
    system "cargo", "install", *std_cargo_args

    ENV["OUT_DIR"] = buildpath
    system bin/"gpg-tui-completions"
    bash_completion.install "gpg-tui.bash"
    fish_completion.install "gpg-tui.fish"
    zsh_completion.install "_gpg-tui"

    rm_f bin/"gpg-tui-completions"
    rm_f Dir[prefix/".crates*"]
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    begin
      r, w, pid = PTY.spawn "#{bin}/gpg-tui"
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
