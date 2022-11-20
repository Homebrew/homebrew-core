class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/1.3.1.tar.gz"
  sha256 "8cd5c7953a94f30eefe5edcee4a76e10e57b60ae9318a1b704c6823b40d09d2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aae599a950ff7fe26508a9458e76795b35d5956dc3e1f36929ca6e8616cbfe28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dbdb4f0989a442794da7daa31b35296214b56e0af22a4a302910a8624fa1218"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2fc3d5e60a5b7e3888b894e8445883835b36842c89112591073ab0f9db4053c"
    sha256 cellar: :any_skip_relocation, ventura:        "c56febb3ad2525afd8c473bb1354c65ce188fc5ed7c326277f89dfc74b8602f0"
    sha256 cellar: :any_skip_relocation, monterey:       "e071134e0636c58ec866d175764f2a5cfbe20b3c223e4033e87740b63daf8e48"
    sha256 cellar: :any_skip_relocation, big_sur:        "1167ba7348db5b58a2036bc1a297ffdd65a221a608198606bbcdc9992d881f42"
    sha256 cellar: :any_skip_relocation, catalina:       "b7d73be8c170ecfaeffc26ce8db449d1bc4dd1a207e91b91f9b5ce8aa3c30eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c616e82a3c89dd387965123616ff1d745b7447ae161001932ebf9e3fd766e96"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libxslt"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
