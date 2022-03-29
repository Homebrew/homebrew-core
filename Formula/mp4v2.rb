class Mp4v2 < Formula
  desc "Read, create, and modify MP4 files"
  homepage "https://mp4v2.org"
  url "https://github.com/enzo1982/mp4v2/releases/download/v2.1.1/mp4v2-2.1.1.tar.bz2"
  sha256 "29420c62e56a2e527fd8979d59d05ed6d83ebe27e0e2c782c1ec19a3a402eaee"
  license "MPL-1.1"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d9455498d43db563aa85f82ac1f2d6c24a991d169a804e3eb5847d29694e8761"
    sha256 cellar: :any,                 arm64_big_sur:  "c80ca531e43f5064215f4a36cfb0cc50d37dc0d20c26c1898ff8953fa4a4ffc9"
    sha256 cellar: :any,                 monterey:       "8681d99982fd6168c8fa3331362aae60828e2ff4e6362d941b7de524b82cfa15"
    sha256 cellar: :any,                 big_sur:        "e29b4006cbd5df13e1f51c23740c09fafcfb8cb5213cc3831c074ebf773b08df"
    sha256 cellar: :any,                 catalina:       "94b95f575752de10d3750f714f91c436e9e35023f037d896bf9f60e1c8f797f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6ee79238286bd16db6368f2b351445cc61571cc956d2f1adf9ef1038065d96a"
  end

  conflicts_with "bento4",
    because: "both install `mp4extract` and `mp4info` binaries"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mp4art --version")
  end
end
