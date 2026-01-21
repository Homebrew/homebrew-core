class Idsgrep < Formula
  desc "Grep for Extended Ideographic Description Sequences"
  homepage "https://tsukurimashou.org/idsgrep.php.en"
  url "https://tsukurimashou.org/files/idsgrep-0.6.tar.gz"
  sha256 "2c07029bab12d9ceefddf447ce4213535b68d020b093a593190c2afa8a577c7c"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(/href=.*idsgrep[._-]v?(\d+(?:\.\d+)+)\.t*/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "599f0677a847ef317bb1cf0a80501b84531bf0a3083f6cf31052bb5f70bab0fc"
    sha256 arm64_sequoia: "1c94fbfcf90ac7576c2b006a8ee3c80f07a4013eebb232eec219b47203b8a765"
    sha256 arm64_sonoma:  "84923961452a0d7c070b7c78375c936fedff5455612aa226e747df022cfa1daf"
    sha256 sonoma:        "d3d1fc3dee5ac6f139f457881bfc85f865ed0ed5dd94fa856396085c9bebcac7"
    sha256 arm64_linux:   "656ffb858db27d6e80c9df19854d995ee1d45c0aaca683b2048125ad8021dc80"
    sha256 x86_64_linux:  "4ba4398d84c8f0d78e838d5b39182bd0eab662606d8a77e895fc663e5558307d"
  end

  depends_on "cmake" => :build

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-pcre",
                          *std_configure_args.reject { |arg| arg["--libdir"] }
    system "make", "install"
    pkgshare.install "chise.eids"
  end

  test do
    expected = <<~EOS
      【䲤】⿰⻥<酒>⿰氵酉
      【酒】⿰氵酉
      【鿐】⿰魚<酒>⿰氵酉
      【𤄍】⿰<酒>⿰氵酉<留>⿱<CDP-8C69>⿰<CDP-88EE>;刀田
      【𦵩】⿱艹<酒>⿰氵酉
      【𫇓】⿳⿴𦥑<林>⿰木木冖<酒>⿰氵酉
      【𬜂】⿱⿴𦥑<林>⿰木木<酒>⿰氵酉
      【𭊼】⿱<酒>⿰氵酉<吒>⿰口<乇>⿱丿七
      【𭳒】⿰<酒>⿰氵酉<或>⿹戈<CDP-8BE2>⿱口一
    EOS
    assert_equal expected, shell_output("#{bin}/idsgrep -dk '...酒' #{pkgshare}/chise.eids")
  end
end
