class Muchsync < Formula
  desc "Synchronize notmuch mail across machines"
  homepage "https://www.muchsync.org"
  url "http://www.muchsync.org/src/muchsync-7.tar.gz"
  sha256 "f83e2f6fcd0ef4813475fddc8d39285686654da5f41565a1e9a9acd781a3beac"
  license "GPL-2.0-or-later"

  head "http://www.muchsync.org/muchsync.git", branch: "master"

  depends_on "xapian" => :build
  depends_on "notmuch"
  depends_on "openssl@1.1"
  uses_from_macos "sqlite"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  service do
    run [opt_bin/"muchsync", "SERVER"]
    run_type :interval
    interval 300
    environment_variables PATH: std_service_path_env
    log_path var/"log/muchsync.log"
    error_log_path var/"log/muchsync.log"
  end

  test do
    system bin/"muchsync", "--version"
  end
end
