class Autobench < Formula
  desc "Automatic webserver benchmark tool"
  homepage "http://www.xenoclast.org/autobench/"
  url "http://www.xenoclast.org/autobench/downloads/autobench-2.1.2.tar.gz"
  sha256 "d8b4d30aaaf652df37dff18ee819d8f42751bc40272d288ee2a5d847eaf0423b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?autobench[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3647ac7b205e7a115aae29fc33d72dc21ab5465b98081711240899fdbde2c096"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e205a771a8b315d263fbfb8cac87e6cf90dec528afeb9d755908a9139a2499cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33abbf1a79c47258e22ff62a94c7d1ec19b304cce3a50780097bd65de10eac99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1395f353dcbb83ca42019534ce574f19eabdfaf6e5fa203f9e16a5c5d199e0a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb1d05812e4ccfb525567d4193b0a567498c7aefe1bdf7b9c632b3100ea3e75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c475644370c0f887d23d5fb77b4c3e24fc31ab21366e35395a8c1214c3f91143"
    sha256 cellar: :any_skip_relocation, sonoma:         "162967bfd95f422dc7189ad99fd61b4f002f2f966e6ad01346aae4fd302dd4c0"
    sha256 cellar: :any_skip_relocation, ventura:        "ebf91a63de293b20f1f7228ea1053543ab09bb63cf381d05caf0af8dfac2a794"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd26e697396773123b3d800a9a19e10f225b58797849a7ecbe1250969baf77c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dde390cbcb35b87f2cf565a59e11ae4997400a37170abd9b276696460f81dbc4"
    sha256 cellar: :any_skip_relocation, catalina:       "02476e73b18bf8ed02b18fa66b1c90133e21ad28223f528532a427060860dbe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "480b1dd43d675961961fe91a4d1f6fd39ba7a4187127d51fa177a694856f0b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f33306a0edae89cab46f98344c30feeab7a3d9d03e1d6c21e578720c8cac794f"
  end

  depends_on "httperf"

  def install
    # Workaround for arm64 linux. Upstream isn't actively maintained
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system bin/"crfile", "-f", "#{testpath}/test", "-s", "42"
    assert_path_exists testpath/"test"
    assert_equal 42, File.size("test")
  end
end
