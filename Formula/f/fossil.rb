class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.23/fossil-src-2.23.tar.gz"
  sha256 "a94aec2609331cd6890c6725b55aea43041011863f3d84fdc380415af75233e4"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fbcd49e68ac1907e98977b8855fcb098da31e4ec2b8f55609684cfbce37d42aa"
    sha256 cellar: :any,                 arm64_ventura:  "6b7f660012148fbcaae115e04859bbda356d2fac607e0138a55beb7d5a431266"
    sha256 cellar: :any,                 arm64_monterey: "f02bef90494315f4aae22eeeb70295c362044032a87ffd290bb0128c7c3297bb"
    sha256 cellar: :any,                 sonoma:         "24a732cb4dd9fc85fad2017e9a92fb91724d8cb3b9025216710b205796e64b7b"
    sha256 cellar: :any,                 ventura:        "e9153babff57ebba943b2b240721b7813f704d139987b6f0c8419ac9f0f88080"
    sha256 cellar: :any,                 monterey:       "961b173165092cbda09160b090b1643eb06ddd4f763fbc068455ff5d5a0bea0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb2c9310b6f2c788691259c7c29ff0e31f824e8f76e19e4b3ddf01eb31d51530"
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
    system "#{bin}/fossil", "init", "test"
  end
end
