class FdkAac < Formula
  desc "Standalone library of the Fraunhofer FDK AAC code from Android"
  homepage "https://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.3.tar.gz"
  sha256 "829b6b89eef382409cda6857fd82af84fabb63417b08ede9ea7a553f811cb79e"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3219079b606e1be7284a0b184c6ccb57676190d199261a0bb67556d28da94c2d"
    sha256 cellar: :any,                 arm64_sequoia:  "d25f4bc81d87c69c9d26d29ae088caeae1778b87f6ca2e13e759ef9d5e723c9a"
    sha256 cellar: :any,                 arm64_sonoma:   "bf2bc2ad387a9d717432c105936aff9fd49b22b0f18fac097e59dd55778ca9e0"
    sha256 cellar: :any,                 arm64_ventura:  "51653e0466e96908261c0ee5af6e257df21a18b789227158018a7515c4daaca1"
    sha256 cellar: :any,                 arm64_monterey: "afd6e5b3398f20cbbac268cd4a992a24c3eeb253eea72ef36fd6235faa53dbd9"
    sha256 cellar: :any,                 sonoma:         "b0c350cb884700c516fbc0ab88a8f600500972f97a6e0031bc1947ef36904c33"
    sha256 cellar: :any,                 ventura:        "635b76c14fa7e66275239c9f4aa8fc6f5a40f94664b03a343e937a0b204e1ebe"
    sha256 cellar: :any,                 monterey:       "44b4edbabe686922c8726e8566b35ea54d83f7036798f907a488b5a2e149d214"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0e22fdcb7f0c9863a317d4a9be3b2baa2e484b2b1885f761872074a58f7040b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90a5fa30abf8a37117855a3a6ac400d35c4f23f9de475ea870ee282c5e5feac2"
  end

  head do
    url "https://git.code.sf.net/p/opencore-amr/fdk-aac.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-example"
    system "make", "install"
  end

  test do
    system bin/"aac-enc", test_fixtures("test.wav"), "test.aac"
    assert_path_exists testpath/"test.aac"
  end
end
