class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://github.com/cminyard/gensio/releases/download/v3.0.3/gensio-3.0.3.tar.gz"
  sha256 "bea4d7015c92e427e3d745d4c6d9712af9cd5629c706c7e19cddf655aeea73c2"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_tahoe:   "bdf033c0df0792ff0097941c8eaba8173ef55cafe8f6b174c5939df8a79141b3"
    sha256 arm64_sequoia: "f872f4d14a18f37fa5e4fcd7104e7591db81d160e99ea16e9b81056d52e0fc7c"
    sha256 arm64_sonoma:  "a3b9dc16c7739a7b292754703af61311efda7c0c80c1dec927578708fdb187fb"
    sha256 sonoma:        "c91f5287120774eede4328bd5526f1b78dd1c11547d780acef696da9571cce72"
    sha256 arm64_linux:   "b250df4b6ca99de1a4c2ab3e94ed6b1ae13b7133c84ee6ad248650f9e1815891"
    sha256 x86_64_linux:  "79f7a08df1a319b5bb7ada1e2244ecd3b24957ac8f8d3259d6ce468ebb0964b1"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "tcl-tk"

  on_macos do
    depends_on "gettext"
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
    depends_on "linux-pam"
    depends_on "systemd"
  end

  def python3
    "python3.14"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    tcltk = Formula["tcl-tk"]
    args = %W[
      --disable-silent-rules
      --with-python=#{which(python3)}
      --with-pythoninstall=#{lib}/gensio-python
      --with-tclcflags=-I#{tcltk.opt_include}/tcl-tk
      --with-tcllibs=-ltcl#{tcltk.version.major_minor}
      --sysconfdir=#{etc}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (prefix/Language::Python.site_packages(python3)).install_symlink lib.glob("gensio-python/*")
  end

  service do
    run [opt_sbin/"gtlsshd", "--nodaemon", "--pam-service", "sshd"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gensiot --version")

    assert_equal "Hello World!", pipe_output("#{bin}/gensiot echo", "Hello World!")
  end
end
