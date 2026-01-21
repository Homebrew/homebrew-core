class Mkcue < Formula
  desc "Generate a CUE sheet from a CD"
  homepage "https://packages.debian.org/sid/mkcue"
  url "https://deb.debian.org/debian/pool/main/m/mkcue/mkcue_1.orig.tar.gz"
  sha256 "2aaf57da4d0f2e24329d5e952e90ec182d4aa82e4b2e025283e42370f9494867"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?mkcue[._-]v?(\d+(?:\.\d+)*)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d749706af2c32c59bc8bc5faa3c64d98ea35cf5e2f758d2080201b6feda10930"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "86b0008a011b784913cbf754e986e22b8164c5d75cc872c599f668c7061f4f8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e8c2ecae6dc26d0931ffb4f1c520a6c2a98aeb135000c9e3edcf67b3f91b5f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4e1acd72551015dad41df1ad038b7507f18b857a03e6653d4c9d1ecf3122125"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a13e835f8be46aa49ced89b84f232f40dc563b9a06481efe25e1d271ea56ab41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ec6570740f47d54de601598229cfa9a2c320dc745fbd72173b0a906b13a65aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "191f4ce6ac2ee39b7c4a503f3583ee94d2352a47fe8700c54701a8295e05e4d9"
    sha256 cellar: :any_skip_relocation, ventura:        "9520bdcf630f2fa825fb050df73a645681d768e5a0975d743def37cab2a45f49"
    sha256 cellar: :any_skip_relocation, monterey:       "f2a6ae19648e6204511cc973856e605773903db8ad4c652166b614b3cee0c096"
    sha256 cellar: :any_skip_relocation, big_sur:        "daddca8c6a5648f6ac6b20228d3817515ea17396c4adfe53740b1ed8f79312b5"
    sha256 cellar: :any_skip_relocation, catalina:       "04a1028cdb9608369a30f1c7f54204963bfd9ccac697d098499846df035c2886"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d0bcd3ad24b610cb79b5b41498a9ec6428a42e921edc2ba21406c0804c176ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ffe89a918fbd678d1dd78349a5cc46d6496f2150215f698560b9e4453f13143"
  end

  def install
    ENV.cxx11
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    bin.mkpath
    system "make", "install"
  end

  test do
    touch testpath/"test"
    system bin/"mkcue", "test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]

    if ENV["HOMEBREW_GITHUB_ACTIONS"]
      if OS.mac?
        system bin/"mkcue", "test"
      elsif OS.linux?
        assert_match "Cannot read table of contents", shell_output("#{bin}/mkcue test 2>&1", 2)
      end
    end
  end
end
