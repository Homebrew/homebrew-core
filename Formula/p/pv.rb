class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.12.0.tar.gz"
  sha256 "31fdbdb449c7143cd2968567bef7599e9f031950e6158ee7bb76e40aebf6ffb8"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "4474aa564a01214715138402980661cf1f4503e2ee21b71640b4adc10e0ead04"
    sha256 arm64_tahoe:       "cd91923ccdde058fb984dc9a25c12cf903ded4da91ac8b33e21c659ffb18c076"
    sha256 arm64_sequoia:     "b9c9b8620083d6686cd48ae66c9db086c6919b8c1946d7cc9fffb20af880530b"
    sha256 arm64_linux:       "31f26810cc198c0c96791eb6e9f0a517dd6ec094ac401bd08463739f4a94507b"
    sha256 x86_64_linux:      "20fb9b8f6b82b6f954345ad449fc182b8deb0be548c27e1984f4d30250317b05"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
