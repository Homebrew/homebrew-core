class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.24/fossil-src-2.24.tar.gz"
  sha256 "e6f5a559369bf16baf539e69e6d0cea5a6410efa9a6e7f160c7a4932080413be"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c642f8df75725e973c7cf30951651ce536baaad12d4dc5c3959920d88078c0b5"
    sha256 cellar: :any,                 arm64_sonoma:   "57017ccd96af0539aa018cf48940242f0c5b32cd2fd31ce25e7faa047924e644"
    sha256 cellar: :any,                 arm64_ventura:  "40dc9b1f55904916ebdc854d88dc6573ba919f43e2266d0323a954c1e6d68243"
    sha256 cellar: :any,                 arm64_monterey: "65798cc7241b7a750814d3b16329a93824ee82a2e71356403ac8b038dfbbd831"
    sha256 cellar: :any,                 sonoma:         "41c32d18fcbd268a84b05586b899ef809f6a39ee6143e3fc6bb7cd688490ae50"
    sha256 cellar: :any,                 ventura:        "7228d43abc37ca6b88547e00f8903d60187e3466204fad3f888c911f2bdd16f8"
    sha256 cellar: :any,                 monterey:       "6f7266e8686f5fff3931c68ec351c09924c291dd650cafdcaeed934c4cf0ad6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea54ffd2dad970235c48c33224d53069af59082106b1639ea91f99c2ccaff70"
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

    args << if OS.mac? && MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
    bash_completion.install "tools/fossil-autocomplete.bash"
    zsh_completion.install "tools/fossil-autocomplete.zsh" => "_fossil"
  end

  test do
    system bin/"fossil", "init", "test"
  end
end
