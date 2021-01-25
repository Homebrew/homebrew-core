class Pit < Formula
  desc "Project manager from hell (integrates with Git)"
  homepage "https://github.com/michaeldv/pit"
  license "BSD-2-Clause"
  head "https://github.com/michaeldv/pit.git"

  # upstream commit to allow PREFIX-ed installs
  stable do
    url "https://github.com/michaeldv/pit/archive/0.1.0.tar.gz"
    sha256 "ddf78b2734c6dd3967ce215291c3f2e48030e0f3033b568eb080a22f041c7a0e"

    patch do
      url "https://github.com/michaeldv/pit/commit/f64978d6c2628e1d4897696997b551f6b186d4bc.patch?full_index=1"
      sha256 "f97a553bc5ca0eddf379e3ca3f96374508f8627e18aaff846786c41d7ba1987b"
    end

    # upstream commit to fix a segfault when using absolute paths
    patch do
      url "https://github.com/michaeldv/pit/commit/e378582f4d04760d1195675ab034aac5d7908d8d.patch?full_index=1"
      sha256 "73651472d98aa02e58fbf6f1cc4ce29100616d6f6d155907c4680eb73217f43f"
    end

    # upstream commit to return 0 on success instead of 1
    patch do
      url "https://github.com/michaeldv/pit/commit/5d81148349cc442d81cc98779a4678f03f59df67.patch?full_index=1"
      sha256 "3ae9004fe9551ab51be44df2195bf5e373e1473a888c11601de0d046322d382f"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "853489d4ee4f37e97f89415f5a3d1e0c225cb2dace8f61680293bb61ad57dd52" => :big_sur
    sha256 "2d3857a0cf9c47d2d53f87109d87a4823fed481398cf2adb6c9f3809b8085985" => :arm64_big_sur
    sha256 "3ff5098a860de65a101fafe58d9ef76ac4c392f0b127720ecb34f0141554c27d" => :catalina
    sha256 "7c23637b9f925de09953cc5288e884ee9c08a5b62b2a16a3596cf6fcfc3c0677" => :mojave
    sha256 "0fcb58f56565c207f8030853336ba313d93ba9bd3f1c09480a0ad37de1d961f2" => :high_sierra
    sha256 "fd6ce87e3c42f5418c28e6a8a60184ac51b596bb59343de5523930980071103b" => :sierra
    sha256 "20064d0b1496360f820f55aae90b0e4adf00a70cb4f607668a6beadd0ae11c08" => :el_capitan
    sha256 "20d5d870a4a2cb926cfcdbf4ad8066281c0bc8c4318e7a74d316077c71fdf175" => :yosemite
    sha256 "f7211a93b715fc54ebe2fde4aba9c6696eafef7133e551ec5b8f9899ba2b5b75" => :mavericks
  end

  def install
    bin.mkpath

    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/pit", "init"
  end
end
