class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/0.32.tar.gz"
  sha256 "a894cfa96c44b9ef48003b2c2104dc5fa6361dd2f4d519261a93178984a51259"
  license "LGPL-2.1"
  head "https://github.com/bup/bup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4bb08d55b8df8f0679f6c41f08211e2ab8ac0a684583122adbee9746d29191f" => :big_sur
    sha256 "3bf19221bf74b4df029c16bc0d2c329ffa8c15299bd8d1ec3bf2fb5b33ef71d6" => :catalina
    sha256 "9c0ece72b212d56a83ebe5540c68851e9fd759dabe05db787cc438aedce022de" => :mojave
    sha256 "9c9515da16e8ba9ed333922a486a042da64e4f7d0986298a8c82420c83b06a7f" => :high_sierra
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end
