class Cdecl < Formula
  desc "Turn English phrases to C or C++ declarations"
  homepage "https://cdecl.org/"
  url "https://cdecl.org/files/cdecl-blocks-2.5.tar.gz"
  sha256 "9ee6402be7e4f5bb5e6ee60c6b9ea3862935bf070e6cecd0ab0842305406f3ac"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36acc58f38ee551b35a2c531d9bdfb8113aee61cbb4bdb9d43646ddcfeba9053"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dcff021c0d0078666c5a4781d738e8958fc52222bb2062b447f581d1b398971"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ffb24daa6ca1e12ddfbc0cf77ef3461dfdc7eec3ba8149e0f5dbacabeefce2b"
    sha256 cellar: :any_skip_relocation, ventura:        "172450bfee9de34b028b40568fbd21662fb6fbf5149343eee624b0cd03766f02"
    sha256 cellar: :any_skip_relocation, monterey:       "484c974a4e2c954bd4c5dc321de2ca4a778be9d55db712cd9913ec2fd67b41ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac04af015afd9bc8d756f4220c53d484de0fba6f0c8a0976f99b63e2bdfccf3e"
    sha256 cellar: :any_skip_relocation, catalina:       "bba9953b96f037148b23ecf85030ed505bf1e6712f21099d494084c26cd52f1c"
    sha256 cellar: :any_skip_relocation, mojave:         "beed8e3f4c2de0b75bd12bd65e6d9ce4a7cb626fac5cd8c5e20426d2b9325840"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a2469d514723e35850b252b97d3bf90f9311c276455b218383d276ccb0c88ee4"
    sha256 cellar: :any_skip_relocation, sierra:         "1d424613881cf9109d824664fc77fc947f2968b9850d448db4b02c6f0a562b5c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "4f0e990d88823aa9f3d1dcea71ffa442c13640ce82cc9da41f90a1be5ef457dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ce7e2b34d87649b10f5cd29b4df13c565f518936b42f029b7d1b592984d237e"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
  end

  def install
    # Fix namespace clash with Lion's getline
    inreplace "cdecl.c", "getline", "cdecl_getline"

    bin.mkpath
    man1.mkpath

    ENV.append "CFLAGS", "-DBSD -DUSE_READLINE -std=gnu89"

    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LIBS=-lreadline",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "install"
  end

  test do
    assert_equal "declare a as pointer to int",
                 shell_output("#{bin}/cdecl explain int *a").strip
  end
end
