class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.19/fossil-src-2.19.tar.gz"
  sha256 "4f135659ec9a3958a10eec98f79d4d3fc10edeae2605b4b38e0a58826800b490"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "148769ddfba888a2cf0150ae0e5847abb136624b3016b89369447f35d6087516"
    sha256 cellar: :any,                 arm64_big_sur:  "53d47387a9272b68a7a0e722461445bd7d8b767e60d1ff047c386e1412219c30"
    sha256 cellar: :any,                 monterey:       "34e2496a017d02b6ac9311b4c0448f8315b2e1616b4b69fcbf6779a041c8a121"
    sha256 cellar: :any,                 big_sur:        "c2b0c25ec37321818a2fe83d0ced4ae6ce03974abea56e3e13a6fa880dc15f30"
    sha256 cellar: :any,                 catalina:       "25abcda832bcd63e3ab02f128a7441871e4e3ed3e5b40f3a5a3c7c6bede6c5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efda12d36d3a799e3ef547f22d32451dbb75d0b9da1dd144a071734b642de1c6"
  end

  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
