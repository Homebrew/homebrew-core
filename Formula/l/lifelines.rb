class Lifelines < Formula
  desc "Text-based genealogy software"
  homepage "https://lifelines.github.io/lifelines/"
  url "https://github.com/lifelines/lifelines/releases/download/3.1.1/lifelines-3.1.1.tar.gz"
  sha256 "083007f81e406fce15931e5a29a7ba0380ef0b3b9c61d5eb5228ad378c7f332d"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "afad3199c003a1f962febd31844f28809700841a38123cef7fb84c64e49ecdcb"
    sha256 arm64_sequoia: "4c61322a31b4c17ae231d831f152f62861a9bf39e407b5b7921f1e98b65c0e86"
    sha256 arm64_sonoma:  "fe930e2a16a38c43cf801160780d2b2cc98cac006a3438cd2957f748226798d9"
    sha256 sonoma:        "178b0ab21e880332fb743988ca4ca590dc0e7b3fd35ec26771227b2d843fc255"
    sha256 arm64_linux:   "36f70d3fb5016ba20ccde01baef923f443a98e35a703a801f38304fb084fc587"
    sha256 x86_64_linux:  "3163ab9f6ebd4cb0e67a1032aa61259369740edb4734e63dca07177d24901939"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llines --version")
  end
end
