class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.34.tar.gz"
  sha256 "c0626bed6cbef5006b53d3281e8e3ae4b2838729462b21eccf28140eefef6bb1"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "40fd0126c46a5f60d00704fdafaaea2d9756a45fc4607e1e4e8ace3aabc4e919"
    sha256 arm64_sequoia: "5178545d9bf9cb5595521fe23f3d81cef9dc1616abeb34a4a470cee04c3d3115"
    sha256 arm64_sonoma:  "da8655acc575c9267e41b941d62649dc5a8ca061da6ba14734e511dd7647a0f0"
    sha256 arm64_ventura: "7cfa691067062a8bbdde607ba85a62dcecaeba9adf3e1f502d9d206230a26dad"
    sha256 sonoma:        "fef7b902b0c0689a3810432952dada632811f73924bf3ab13c528897fa2a0d5b"
    sha256 ventura:       "e8f5c06b8b8764622cea6bfb54a4982630bb5a5ae2e11d3422493b157e9dccbd"
    sha256 arm64_linux:   "42da7fceb87479d86d6bef999b19991467db067a6452d3c77a508f1abbf0d81d"
    sha256 x86_64_linux:  "8d3a627b9799aaf24376fed7d93f9b9a93b5ae23bcfedcb57404389507842572"
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
