class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v2.6/advancecomp-2.6.tar.gz"
  sha256 "b07d77735540409771cbe1b6df165b5151c11bb9c3d8f01290be0ec88ec3498f"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2862d3598f6f87ae56c243ebc30fffc8e2249ed68554be1d2e87ef3b3b791edd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5777e7f8547c26b139edefeaf97664e1f8140947043ac1edc932ff03d58eac66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "847145cf9a8712c77732c65eb448cba870e669606e84a9014cb9757a02a8ed2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c1276ea10b780d85270c5a8147dccfedbc646ced65525deecf797b52e480396"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cba21d82da0f9bdb1971dcf7eea4b452aebef5ce609e286bdfc12a546b3e768"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee89dce9384c81e60d5bd776cc63401e01f3b7ca54b13e95caf08d79fc195640"
    sha256 cellar: :any_skip_relocation, ventura:        "bff1aa324fdb1cbeea5f49d22e5bfd3eb2e9b1d7c59b6735dbdf41e37ca7ba1e"
    sha256 cellar: :any_skip_relocation, monterey:       "0cee2346975f74c9e601ccd07704a820d0aed34751ced2df5df0767d38a7d504"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "58852c7c4a248abf531cd35832281b6c9d4b618826690415687a28f9a05259c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1329faa8c59e53b7570dbed75709d2dc07d3fcbf1ac6610ccee09c817aee056"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--enable-bzip2", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"

    cp test_fixtures("test.png"), "test.png"
    system bin/"advpng", "--recompress", "--shrink-fast", "test.png"

    version_string = shell_output("#{bin}/advpng --version")
    assert_includes version_string, "advancecomp v#{version}"
  end
end
