class Joe < Formula
  desc "Full featured terminal-based screen editor"
  homepage "https://joe-editor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.8/joe-4.8.tar.gz"
  sha256 "6995b28ee20dcdbbcb5a45a4c110642dc96d67748aea27450c74cdb4dd07cc20"
  license "GPL-1.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/joe[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "78fb6ee8e904471bb40ca0dfd1f285478219978a7f8315b819c6e982ab593ef4"
    sha256 arm64_sequoia: "83c44e48090a8681c86cfbab4d150cbe18da6cc43b69eec5b5115f84b6c0fa14"
    sha256 arm64_sonoma:  "10770f03ee4885b9dd4e731a4a1d100ccc14626410bbe60923febeb29090fbe6"
    sha256 sonoma:        "a69fb2fc9b2f3dd70f26f26213fc454323279e91a49d89e73e32e81ca366bc9b"
    sha256 arm64_linux:   "d7d843efe8f1486e22fa278628ede32b9439d26a1e9e1c219273c661d48aaece"
    sha256 x86_64_linux:  "d734e07b2ed595252c020be04a2a36b0990936c8d15091757023e9a79fcaaed8"
  end

  conflicts_with "jupp", because: "both install the same binaries"

  def install
    # fix implicit declaration errors https://sourceforge.net/p/joe-editor/bugs/408/
    inreplace "joe/tty.c", "#include \"types.h\"", "#include \"types.h\"\n#include <util.h>" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
