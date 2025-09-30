class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftpmirror.gnu.org/gnu/hello/hello-2.12.2.tar.gz"
  sha256 "5a9a996dc292cc24dcf411cee87e92f6aae5b8d13bd9c6819b4c7a9dce0818ab"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5eafb7348c3b7253714c061785a67f7878f36e953b454f04a80ec9c62482720"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e81841d7339d3d83c7fbc3ba2f0ba20d9719b2b6e4db7acd47b5ed3c1ca9448c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80309bb8f4140c2d596adaa5de91672aa95456cc659d6682d3e53821f5270879"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d0af0d9c4764328e335fa17167ea8a021c04e9e5709163ac6c7c6b9c60218bc"
    sha256 cellar: :any_skip_relocation, tahoe:         "ab550a2d4c205ec56579129063cfdabe1cc893639a0f2d8be944456f5003aa6a"
    sha256 cellar: :any_skip_relocation, sequoia:       "1bd2d1b2929b7288ed104189e41dbf1499cb7af5a7f789efc99ab49f04e28257"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cfd594bc398a53903002973504298115f713422d74b6ff688e5c4bff86d2449"
    sha256 cellar: :any_skip_relocation, ventura:       "3683c04b8c21b76c563ef34cfb18bb3f021866d723cbcbd0d4f6b7b229a9ffe6"
    sha256                               arm64_linux:   "b40508b42deb96206c71f987d3eab3da6e558f4217f92421c0f02da70f7a6881"
    sha256                               x86_64_linux:  "bc74355f9ea73a40f629dd7e5adcaaad7c0ac7ffda2f3acc860bd7e52baabb94"
  end

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
