class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "https://www.nongnu.org/lzip/"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lzip-1.26.tar.gz"
  sha256 "641cf30961525cbe3b340cc883436c8854e9f5032f459f444de4782b621e6572"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/"
    regex(/href=.*?lzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7450bd58e628ca9ed2747dbf9b858f840a655f1ad0f1c7423dddea54162651d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83c1d91f244efdad75952169fd7b24f7a909057f48095bbe82b17afd567e0efc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5cb50f0bc7144d6613498688a4247083529bf5eea95e45bc39a5d42b3de17b0"
    sha256 cellar: :any_skip_relocation, tahoe:         "75c80c589d55fdab99dbc18edf2def2b676d810c3511a965bbab9cd5d4c5078d"
    sha256 cellar: :any_skip_relocation, sequoia:       "ef78e60a8a37ecd05151fe4dff434c6b402b0687dda60b6d84578561184711af"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fbe0a67e5b4d1997c54a07ae733df3e8f80e2cd665a780fad499e6d7fd64d9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f681af915aa69d942b9842156d384e157f07f0dc6e3c5ba05cad3c72d330cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1970bca2bc7ba6d62ba4aa7fe95d386d2277232d7ff57169691ba2297a6b3264"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system bin/"lzip", path
    refute_path_exists path

    # decompress: data.txt.lz -> data.txt
    system bin/"lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
