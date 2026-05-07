class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.28/fossil-src-2.28.tar.gz"
  sha256 "84c18824ca227e7602d2408b663c3747f754ad306ed5c73ddab959d6589538a6"
  license "BSD-2-Clause"
  revision 1
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "5e31addaca063b247a0ea3f933cec94cd2c717f8f5b35f60649acd26d4b98e16"
    sha256                               arm64_sequoia: "addc876425062178960ac5ff4695d46bf417878ead65c0e46e9d57e01d7a2557"
    sha256                               arm64_sonoma:  "09030560e1be034a443999998de141921355eab8b7ffb8e26314ab80294641c8"
    sha256 cellar: :any,                 sonoma:        "2017f745d7c51b24533c2c094a16061f132284ce8879780e3c12b4136fbef678"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab82a9960b2bcd26a6b17e10738300dfc81108033ecfb54ede06d246c999c4e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3de76c97f0f4df6411d1198c56cbffe8d4f2dd5996f9646fff6ce3b0a4be7f6"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
    bash_completion.install "tools/fossil-autocomplete.bash" => "fossil"
    zsh_completion.install "tools/fossil-autocomplete.zsh" => "_fossil"
  end

  test do
    system bin/"fossil", "init", "test"
  end
end
