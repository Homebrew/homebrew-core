class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.16/fossil-src-2.16.tar.gz"
  sha256 "fab37e8093932b06b586e99a792bf9b20d00d530764b5bddb1d9a63c8cdafa14"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2e974db6852c2a27177bfde0f00c61d81e93f13a2e9c0b2c46d8939b44eb54af"
    sha256 cellar: :any,                 big_sur:       "8608e819d0776acf97e64e1cd7be502d3e799e0b0887a7771a9e73eca742b2ec"
    sha256 cellar: :any,                 catalina:      "eef6ab952149d3ba4aef47eeb13bfda10b0f0d210636bdd975fc384d5ffbe2f7"
    sha256 cellar: :any,                 mojave:        "1640523e40fa4032c6a3afc04b9f3d9993201e91daac8415f8bee81df9c98b88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3a5e435b6d4fc982e4c700463d9ff8d3009b5f514ff0e776cd8eed0b68922f9"
  end

  depends_on "openssl@1.1"
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
