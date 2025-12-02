class Bookloupe < Formula
  desc "List common formatting errors in a Project Gutenberg candidate file"
  homepage "http://www.juiblex.co.uk/pgdp/bookloupe/"
  url "http://www.juiblex.co.uk/pgdp/bookloupe/bookloupe-2.0.tar.gz"
  sha256 "15b1f5a0fa01e7c0a0752c282f8a354d3dc9edbefc677e6e42044771d5abe3c9"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?bookloupe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5fdd9c33dda4df9eb880724c9ebf43aba9c5c9ebcd3eaa3659c06dee3506a9af"
    sha256 cellar: :any,                 arm64_sequoia:  "7ba3e588146783e6f0257c71de17fd54e6f4690c272790982b98f58bbfbf62f3"
    sha256 cellar: :any,                 arm64_sonoma:   "24bf9a6ae43fe3f89408a72d83f31b770ed3a34b8cd1bc2a8966418015b0035c"
    sha256 cellar: :any,                 arm64_ventura:  "4421a88b7f0f464d3469a652e232134ae0f9402c48201515a3c04f9e9f267c45"
    sha256 cellar: :any,                 arm64_monterey: "f981bcea12ecb29401b723391ccf8a7b47ba68bf57dd7277cc4474fc3e0767af"
    sha256 cellar: :any,                 arm64_big_sur:  "52b3382b76c8ef2e8edd46e3bcbe56620d659713f0e8fc4a4fe3e109fc25d7ca"
    sha256 cellar: :any,                 sonoma:         "ee90301308017763e04f2d40a2ba8e50a3adb0b9015e23f59f1b211ce3563c69"
    sha256 cellar: :any,                 ventura:        "f39f6f8a9a229fcd14e1784dd57f1215afae5f8473ce0508392e64ba8063d540"
    sha256 cellar: :any,                 monterey:       "b2df92066e4e19f5a6c9eb4c0784b9f736e1e9043dcb83798e7f2bdf02295942"
    sha256 cellar: :any,                 big_sur:        "7ccdee4a97e6c705e478e38aeca1648b06a39c2edfcfa807a4a07ab12eb0d3c8"
    sha256 cellar: :any,                 catalina:       "83e920e882a00717b094b14477917ed477fa3ab9ae02433d79bf4d374d5723a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a0c355266c0aa5d07d939056e39cd9747d893d84e8f80814d7b75d6483e8ddba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7cdc047eeed0574f7b0c8bccae751fa4b047b0a2aa30d71153960b75b52444"
  end

  depends_on "pkgconf" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--disable-silent-rules", *args, *std_configure_args
    system "make", "install"
  end

  test do
    ENV["BOOKLOUPE"] = bin/"bookloupe"

    Dir["#{pkgshare}/*.tst"].each do |test_file|
      # Skip test that fails on macOS
      # http://project.juiblex.co.uk/bugzilla/show_bug.cgi?id=39
      # (bugzilla page is not publicly accessible)
      next if test_file.end_with?("/markup.tst")

      system bin/"loupe-test", test_file
    end
  end
end
