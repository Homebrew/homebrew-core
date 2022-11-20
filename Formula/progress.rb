class Progress < Formula
  desc "Coreutils progress viewer"
  homepage "https://github.com/Xfennec/progress"
  url "https://github.com/Xfennec/progress/archive/v0.16.tar.gz"
  sha256 "59944ee35f8ae6d62ed4f9b643eee2ae6d03825da288d9779dc43de41164c834"
  license "GPL-3.0"
  head "https://github.com/Xfennec/progress.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97145efe8aa3701c8f6327c23a029827ab755b737f9768608f86c72a7cb5e95a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95538fd7595dfdb2d046961264df824fd0ad908afaf732b6bbd2e5ddf13af2ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97407ff56c65c8f77371ce073478868eb507742db82c11e107a43413bce646c3"
    sha256 cellar: :any_skip_relocation, ventura:        "575b87849ef9d8e50e80d169304c65568a9c2b3a8d69590dded348cebc4fe3c0"
    sha256 cellar: :any_skip_relocation, monterey:       "8a8e247b7fd7ba0c6bd3556739b283d4609ee32ce82b986637a6d1d823a9cf31"
    sha256 cellar: :any_skip_relocation, big_sur:        "21a1663abf8e1a60baf99a3ae46d41883cd5136fabbe77dd07987e0730b08ec0"
    sha256 cellar: :any_skip_relocation, catalina:       "804256c3be440464694fe8f0e9b94f323860f9fa2304c8984dc0e8cbbce43fab"
    sha256 cellar: :any_skip_relocation, mojave:         "5c834228aa86062624e1d2f6f3c386607d3151842218eb9c70529e1485ee1e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31559faf7e06989812f6ea8069a8baf8de1b1abcd68c41dba11f5f2004595f65"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    pid = fork do
      system "/bin/dd", "if=/dev/urandom", "of=foo", "bs=512", "count=1048576"
    end
    sleep 1
    begin
      assert_match "dd", shell_output("#{bin}/progress")
    ensure
      Process.kill 9, pid
      Process.wait pid
      rm "foo"
    end
  end
end
