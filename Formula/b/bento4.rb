class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-640.zip"
  version "1.6.0-640"
  sha256 "abc319b553d6c3540e38e30a6286ef113118c1298ac80f37994a376db331ab6e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29eacfbc2a591a8993f0f1a67d7b2f09ea3b9e22b62de77b2b171c46e2b4801f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06e22f1b67f96e5f58d907b4b86a430005f972a19ff7497827bd55236a440dbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7d1155f3e4b8b7fe5e3018f152d6adfff3cbea1d54e11530f0ffdfe8447b2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c2b5e908cbe12f10fa17d253d7466e31362ddf170b8e1e32b3ab5bfb4cf731e"
    sha256 cellar: :any_skip_relocation, ventura:        "74d680dec16a85cfe2a6f8ca7a6113c2248a4789bbe6218889ca750c649ebc21"
    sha256 cellar: :any_skip_relocation, monterey:       "abb807eb1bfc0156e90722a436d91d183feb495124ab0c8a4b18800149df6640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "341411d696ee13840263ad7bf2362e38d8630bf3e6dfe0548b2952a97be3dc7e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  conflicts_with "gpac", because: "both install `mp42ts` binaries"
  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  def install
    system "cmake", "-S", ".", "-B", "cmakebuild", *std_cmake_args
    system "cmake", "--build", "cmakebuild"
    system "cmake", "--install", "cmakebuild"

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
