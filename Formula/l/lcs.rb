class Lcs < Formula
  desc "Satirical console-based political role-playing/strategy game"
  homepage "https://sourceforge.net/projects/lcsgame/"
  url "https://github.com/ashley-s-fox/Liberal-Crime-Squad/archive/59744167aff8d39b8e4b36fa2b529ad5671c9dd0.tar.gz"
  version "4.07.4b"
  sha256 "77832463f2c244e346b869d6e8586856d34134e32df02a3a1c54a7efd77ca445"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/lcsgame/code/trunk"

  # This formula is using an unstable trunk version and we can't reliably
  # identify new versions in this case, so we skip it unless/until it's updated
  # to use a stable version in the future.
  livecheck do
    skip "Formula uses an unstable trunk version"
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "e1337574ab0f0a762f957bc96874e00e871086f3d9cfac3b195bf0c5c198b619"
    sha256 arm64_tahoe:       "14f9dc85cb94b9c21c15d3fa7c5f93bb917ef4f51b86e5fcd9a93a04ba099ccb"
    sha256 arm64_sequoia:     "5371664ecbf4b18cf50245e6aac09ebd817ec4fb64d9803e17af20550fa298a6"
    sha256 arm64_linux:       "d8bb80fe3edae6cdf7a0a8337102b10926f3c7740d7012b48bbf0f4697415c9e"
    sha256 x86_64_linux:      "904d28296fecd92809997c0c3988d371d0373e5acaa1c4e45c39ccd51daa77db"
  end

  # Last version update was 2013-10-20 and last activity was 2015-09-25.
  # Since then, multiple forks have been in use by community, i.e.
  # https://github.com/Kamal-Sadek/Liberal-Crime-Squad and
  # https://github.com/King-Drake/Liberal-Crime-Squad, but
  # these won't meet Homebrew's exception as no major distro packages lcs
  deprecate! date: "2026-10-17", because: :unmaintained
  disable! date: "2027-04-17", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  deny_network_access!

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-c++11-narrowing" if DevelopmentTools.clang_build_version >= 1403

    system "./bootstrap"
    libs = OS.mac? ? "-liconv" : ""
    system "./configure", "LIBS=#{libs}", *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"
    require "expect"

    PTY.spawn({ "TERM" => "xterm", "HOME" => testpath.to_s }, bin/"crimesquad") do |r, w, pid|
      r.winsize = [25, 80]
      refute_nil r.expect("Inspired by the 1983 version of Oubliette", 15), "Expected title screen"
      refute_nil r.expect("Liberal Agenda!", 10), "Expected title screen prompt"
      w.write "\e"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end

    assert_predicate testpath/".lcs", :directory?
  end
end
