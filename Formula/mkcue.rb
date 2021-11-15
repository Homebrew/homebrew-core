class Mkcue < Formula
  desc "Generate a CUE sheet from a CD"
  homepage "https://packages.debian.org/sid/mkcue"
  url "https://deb.debian.org/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz"
  version "1"
  sha256 "2aaf57da4d0f2e24329d5e952e90ec182d4aa82e4b2e025283e42370f9494867"
  license "LGPL-2.1"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a13e835f8be46aa49ced89b84f232f40dc563b9a06481efe25e1d271ea56ab41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ec6570740f47d54de601598229cfa9a2c320dc745fbd72173b0a906b13a65aa"
    sha256 cellar: :any_skip_relocation, monterey:       "f2a6ae19648e6204511cc973856e605773903db8ad4c652166b614b3cee0c096"
    sha256 cellar: :any_skip_relocation, big_sur:        "daddca8c6a5648f6ac6b20228d3817515ea17396c4adfe53740b1ed8f79312b5"
    sha256 cellar: :any_skip_relocation, catalina:       "04a1028cdb9608369a30f1c7f54204963bfd9ccac697d098499846df035c2886"
    sha256 cellar: :any_skip_relocation, mojave:         "8efe5acfdcd27c465e5b570d4d0a602370912fa83dd6edbe73b26144e420429c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "284cfe9fe5a81a75f59610d93710627167dbc48c1d72b89311562c87cea8f8ff"
    sha256 cellar: :any_skip_relocation, sierra:         "b1bec8cabaddb6a78a3c2e0a13f73eb426922b64e6d9ef3c0103e92e203f6af4"
    sha256 cellar: :any_skip_relocation, el_capitan:     "7677f358f99d733a6f43d02cbf5365f3c59b4f93c6a59ee05bd48045a12cbb52"
    sha256 cellar: :any_skip_relocation, yosemite:       "ddd5ad0b0a05a4fe74e0bfa18390370f547e3d21c00fa2499e50021ea3482ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ffe89a918fbd678d1dd78349a5cc46d6496f2150215f698560b9e4453f13143"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    bin.mkpath
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system "#{bin}/mkcue", "test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]

    if ENV["HOMEBREW_GITHUB_ACTIONS"]
      on_macos do
        system "#{bin}/mkcue", "test"
      end
      on_linux do
        assert_match "Cannot read table of contents", shell_output("#{bin}/mkcue test 2>&1", 2)
      end
    end
  end
end
