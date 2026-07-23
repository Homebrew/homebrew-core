class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.12.2.tar.bz2"
  sha256 "7ce358b18a7f37bcc97a09b4efd89fdadd54cd8e7032db345f61e66dd04b1c3f"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a229fdc150b9c044762ea45c12b41e516b630e306bffdb41cc304e575854b07c"
    sha256 arm64_sequoia: "48d2599d4609f941acb54604b8b764809b5a251bd889a663a6cee3b266f062c8"
    sha256 arm64_sonoma:  "cd3fa54ca32eae4cfc7872389931bd914e28b61b022b0c11cc1fd11c46b3e7df"
    sha256 sonoma:        "4703dff6da28df336f891d4e33f45f964e80475a070b9e4b0d8a1b7a46f6b58e"
    sha256 arm64_linux:   "4bf4fb9c8248721f8faf067433e9b5d007fb69c9f7fc39e0e3e9f4577457347c"
    sha256 x86_64_linux:  "052e4b873c6f2135538a61580112feacc073fc918777267076ef19a225105fd7"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
