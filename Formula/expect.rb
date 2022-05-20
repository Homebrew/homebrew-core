class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://core.tcl-lang.org/expect/index"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz"
  sha256 "49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34"
  license :public_domain
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/expect-?v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "865f91b99656011e6c4cb681a5d5306805f97532158e25eaa6ba74685c9cfc72"
    sha256 arm64_big_sur:  "aacaef6b4ae9a82f8039722e623ad66117e1154f9ddc0f4cf3a7c450147ba010"
    sha256 monterey:       "65f7837ddba5bc6efe90b201e853fa117a617e711074546444b98c665238f1d8"
    sha256 big_sur:        "b7824e3cc83c7b063198bb7505bbd723481327ff40d36ac91ba8950621bcbc49"
    sha256 catalina:       "366066798dba96afbfbbf5b262bb3df9e6405e79b1e4d7160dd9610308ec4b3e"
    sha256 mojave:         "da69b859dd682d61f2380523c3e1afbed2d06e453d4e88e0ce6bb5566df24082"
    sha256 x86_64_linux:   "518fab49b38bf1b7ce6118907dec39e476c4f57e0c1a3dbfc2113d95a6c1760b"
  end

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "tcl-tk"

  conflicts_with "ircd-hybrid", because: "both install an `mkpasswd` binary"

  def install
    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --enable-shared
      --enable-64bit
      --with-tcl=#{Formula["tcl-tk"].opt_lib}
    ]

    # Temporarily workaround build issues with building 5.45.4 using Xcode 12.
    # Upstream bug (with more complicated fix) is here:
    #   https://core.tcl-lang.org/expect/tktview/0d5b33c00e5b4bbedb835498b0360d7115e832a0
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    # Workaround for ancient config files not recognising aarch64 macos.
    am = Formula["automake"]
    am_share = am.opt_share/"automake-#{am.version.major_minor}"
    %w[config.guess config.sub].each do |fn|
      cp am_share/fn, "tclconfig/#{fn}"
    end

    # Regenerate configure script. Remove after patch applied in newer
    # releases.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir[lib/"expect*/libexpect*"]
  end

  test do
    system "#{bin}/mkpasswd"
  end
end
