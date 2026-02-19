class Bstring < Formula
  desc "Fork of Paul Hsieh's Better String Library"
  homepage "https://mike.steinert.ca/bstring/"
  url "https://github.com/msteinert/bstring/releases/download/v1.0.3/bstring-1.0.3.tar.xz"
  sha256 "90db08fd33e9494aea3f00f9b71cdcf3114c65457ee35558e8274df6ebac43f3"
  license "BSD-3-Clause"
  head "https://github.com/msteinert/bstring.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24503d1d048147dd52f869dadf9798aff2a658f0c79b6fc04239dc3fe91b8087"
    sha256 cellar: :any,                 arm64_sequoia: "57539d29c82c298ddb0796cebbdcb5f487d9d9439403bc871331fae77a6360ba"
    sha256 cellar: :any,                 arm64_sonoma:  "1a12d3cf35ca6e75f822d558209b4c7012c581442c8413dcb1b420905705905f"
    sha256 cellar: :any,                 sonoma:        "3b7912d21554db0be416ba7b2d397062e3147463ca3ab62b6fecff5240e928f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94f20278cd1ff242a9015e59d4572f4e65a85dec934e9fcc6f81bd416b664ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6f4ee274a77d1f62fa1220c2deffe2e08bb5e86ae39b993fae50813099b66a4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "check" => :test

  def install
    args = %w[-Denable-docs=false -Denable-tests=false]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/bstest.c", "."

    check = Formula["check"]
    ENV.append_to_cflags "-I#{include} -I#{check.opt_include}"
    ENV.append "LDFLAGS", "-L#{lib} -L#{check.opt_lib}"
    ENV.append "LDLIBS", "-lbstring -lcheck"

    system "make", "bstest"
    system "./bstest"
  end
end
