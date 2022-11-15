class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.2.tar.bz2"
  sha256 "fce01ccac59812bddadffacff017dac2e4762bdb6ebc6ffe06f6ed4f6192c971"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2c09ce09a6e6f5e09dd8a84cf255b061afb2c9f9f0f91851a8ce6c186cfbdf95"
    sha256 cellar: :any,                 arm64_monterey: "2042f59a89e3a727c9c9121d7d027cd44b1edb16453dce2d2c9d47c3b8e6aa4f"
    sha256 cellar: :any,                 arm64_big_sur:  "db844c848945c79498bddf79b6ceb60c1cc45c684b501cf3ff2fe57f9937b976"
    sha256 cellar: :any,                 ventura:        "dec49cecb234e5c092ad1d38ce068b8ca04cf639c5548661201dce22b4ba2532"
    sha256 cellar: :any,                 monterey:       "8128c13f0baf8d082a45a173060aba740105fdc4acda53d8aae6501a3612bd4a"
    sha256 cellar: :any,                 big_sur:        "d632c840b68cd06544f1fe942cd075985aa17b046379c4fb8508a85f4eda0241"
    sha256 cellar: :any,                 catalina:       "288938ed99cf5ed6b99b56db8bf41ddcacf373acc459ef1c495082200ce9a1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c743fb137f06e9d98612227e3da403281f8ec30e9725560222481d9c2de6db0a"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"ksba-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end
