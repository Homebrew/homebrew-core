class Beansdb < Formula
  desc "Yet another distributed key-value storage system"
  homepage "https://github.com/douban/beansdb"
  url "https://github.com/douban/beansdb/archive/v0.7.1.4.tar.gz"
  sha256 "c89f267484dd47bab272b985ba0a9b9196ca63a9201fdf86963b8ed04f52ccdb"
  license "BSD-3-Clause"
  head "https://github.com/douban/beansdb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98bdf58195eda75aba9fc8d1b32cd25252e3ff5eb3957ae626e40b740c8a4d58"
    sha256 cellar: :any_skip_relocation, catalina:      "9838cb03ef9bdaa895e5ceddeb32be9d3895d8f2d055394cce822e6c44262ee7"
    sha256 cellar: :any_skip_relocation, mojave:        "895c915b759be757dede0375aaf5abaf05a0f5f981d869c6c61367645fd2a564"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a8afd6d03a43a317c306f1de555edc6f804ddb4798ab88d93d9cfb3705887d8f"
    sha256 cellar: :any_skip_relocation, sierra:        "0c93cb38fd445baab2c301b3cb76ce0b6c7af9d3e879113d4c78bf761756bc08"
    sha256 cellar: :any_skip_relocation, el_capitan:    "5bb5311949ba21cde40848d1c1f58cf3317d8e8d604d3d0590dab2e9953a5ece"
    sha256 cellar: :any_skip_relocation, yosemite:      "e3c0bfa02e012ef1b0935fe13be8286dce080e8898b6519f5bf8c886ea77b9bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68026b56a9740bd94604db245da7c803865dcbfb19a6d7379bfb7dfb251f4ab2"
  end

  # Deprecated upstream in favor of `gobeansdb`:
  # https://github.com/douban/gobeansdb
  deprecate! date: "2018-06-11", because: :repo_archived

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    (var/"db/beansdb").mkpath
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"beansdb", "-p", "7900", "-H", var/"db/beansdb", "-T", "1", "-vv"]
    run_type :immediate
    keep_alive true
    error_log_path var/"log/beansdb.log"
    log_path var/"log/beansdb.log"
    working_dir var
  end

  test do
    system "#{bin}/beansdb", "-h"
  end
end
