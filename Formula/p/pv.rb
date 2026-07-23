class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.11.0.tar.gz"
  sha256 "fc02c9fc2b82b20a92cc8d98f844be63f22abd98751a8e4abc875e1d803662eb"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9e8ab3661bc5ebd768e0836f670fd78d90baf7e1795a16d834bdc9ad0944a49a"
    sha256 arm64_sequoia: "9e8eecddf45c70be9f069d6bd808506809f97abe96508aaba6ec6032dc96a9d6"
    sha256 arm64_sonoma:  "5d0ea229f2ed2abedd5b8ae1057ba4125f7ec77dc276a89a0e93066d19276747"
    sha256 sonoma:        "6773edfb4d294ba98f68712251f4b515be9a6ed7c064de7f5c6cefe1cf06ee32"
    sha256 arm64_linux:   "6f5a85e40a48e8ee3c6ce0e38a8b272e6c5f8fc3aa1327066563ba2ef8f628ab"
    sha256 x86_64_linux:  "5e62f57591230be3f63bed28bdbbc45f3fa83d69e0f5db23f0283e2a0c1ddf01"
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
