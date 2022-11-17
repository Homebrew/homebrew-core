class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.20/fossil-src-2.20.tar.gz"
  sha256 "0892ea4faa573701ca285a3d4a2d203e8abbb022affe3b1be35658845e8de721"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "eefd616668ba37cb18a205a0a1738f967b908b8a4775ef3b135a392ea3d0e528"
    sha256 cellar: :any,                 arm64_monterey: "a5c69e1084ad4308ca069ec1704036c45a6c39857a895737e9ed9655c7599702"
    sha256 cellar: :any,                 arm64_big_sur:  "fe04cf19e9342cf2c0056da5f99955044dd19eb3c503168699bcd6f379900590"
    sha256 cellar: :any,                 monterey:       "61835166100565574909da547d3ef3c63c25cfffd3986257b02a471f72b75937"
    sha256 cellar: :any,                 big_sur:        "a379e88999b0dcc19f6fcfd739bd5719e610fbfdcb003233d73015ac0c1a1ed1"
    sha256 cellar: :any,                 catalina:       "1bf891fe9b66948d5fbda2a011d3b430c630cb609c9214184f3521b6d5e0a937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc6f347f269d69eae4bad0f405704ac965759b6c8187fcaa92d4395cbcb8e753"
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
    bash_completion.install "tools/fossil-autocomplete.bash"
    zsh_completion.install "tools/fossil-autocomplete.zsh" => "_fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
