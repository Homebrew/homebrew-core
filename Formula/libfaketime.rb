class Libfaketime < Formula
  desc "Report faked system time to programs"
  homepage "https://github.com/wolfcw/libfaketime"
  url "https://github.com/wolfcw/libfaketime/archive/v0.9.10.tar.gz"
  sha256 "729ad33b9c750a50d9c68e97b90499680a74afd1568d859c574c0fe56fe7947f"
  license "GPL-2.0-only"
  head "https://github.com/wolfcw/libfaketime.git", branch: "master"

  bottle do
    sha256 monterey:     "0ec1aa518fba8d2e20ff358fdeac7ab640488eeb47dcbdf7900601d53c79b7ce"
    sha256 big_sur:      "d852f9c059965fb8750e5202c6b59ed6806dbc19d0aac339dfec71cca3856dbc"
    sha256 catalina:     "c826fdd7a0b8b1be7a8957665ddf3403bbc9e12f9da052a616e714c80c429602"
    sha256 x86_64_linux: "a30d8e38cbe2d90d06ceb803a766750c07c5b2034931db350b6eca7879343eae"
  end

  on_macos do
    # The `faketime` command needs GNU `gdate` not BSD `date`.
    # See https://github.com/wolfcw/libfaketime/issues/158 and
    # https://github.com/Homebrew/homebrew-core/issues/26568
    depends_on "coreutils"
    depends_on macos: :sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    cp "/bin/date", testpath/"date" # Work around SIP.
    assert_match "1230106542",
      shell_output(%Q(TZ=UTC #{bin}/faketime -f "2008-12-24 08:15:42" #{testpath}/date +%s)).strip
  end
end
