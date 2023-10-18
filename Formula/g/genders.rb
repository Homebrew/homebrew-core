class Genders < Formula
  desc "Static cluster configuration database for cluster management"
  homepage "https://github.com/chaos/genders"
  url "https://github.com/chaos/genders/archive/genders-1-28-1.tar.gz"
  version "1.28.1"
  sha256 "3ca8b4771b2bf39383a3c383d36d308fa113de5c481e16fdef9cabd643359d09"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^genders[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "437ba4a56efa72c010639e4aa88f5a0d244d52ea51f69c76d339e60de86d65d2"
    sha256 cellar: :any,                 arm64_ventura:  "4afbf91d200629d7de4d997001f1257ad288f3c9dcb3b1c267189d55ce47115d"
    sha256 cellar: :any,                 arm64_monterey: "f01d9982f8779d112b416c036e0f0179e1b0f9d4a7a19fb7b9901029f42f2b20"
    sha256 cellar: :any,                 arm64_big_sur:  "c006a6102181fe3e5ab3739497a8262d097a85697cd4e723bc0ec5d0729c5950"
    sha256 cellar: :any,                 sonoma:         "1f524f2ac014e2602a48e365d03dd815f871662ada2981615645a2d3e8b1e192"
    sha256 cellar: :any,                 ventura:        "e6cb4a85978c83c60d9d16cc1a7c204cdf4e8978cc34cf100514b225836e39b9"
    sha256 cellar: :any,                 monterey:       "2f39ce129041a6b85659bea7b9e928d3930054a4a7a5c6203b8a93fa09e74cfa"
    sha256 cellar: :any,                 big_sur:        "9b83b2e1ff95368310d065d3d2ca2866511a03bd32ca160b556b7b0c34b00908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acc1b66d1ec7f76ca49fa929b7909bd7058ba0c4e4c6fd741d1cb3843c8f37b5"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    ENV["PYTHON"] = which("python3")
    system "./configure", "--prefix=#{prefix}", "--with-java-extensions=no"
    system "make", "install"

    # Move man page out of top level mandir on Linux
    man3.install (prefix/"man/man3").children unless OS.mac?
  end

  test do
    (testpath/"cluster").write <<~EOS
      # slc cluster genders file
      slci,slcj,slc[0-15]  eth2=e%n,cluster=slc,all
      slci                 passwdhost
      slci,slcj            management
      slc[1-15]            compute
    EOS
    assert_match "0 parse errors discovered", shell_output("#{bin}/nodeattr -f cluster -k 2>&1")
  end
end
