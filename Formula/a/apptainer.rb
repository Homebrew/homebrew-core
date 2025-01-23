class Apptainer < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https://apptainer.org/"
  url "https://github.com/apptainer/apptainer/releases/download/v1.3.6/apptainer-1.3.6.tar.gz"
  sha256 "b5343369e7fdf67572f887d81f8d2b938f099fb39c876d96430d747935960d51"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "114682ef95d8aa78a708dfe4b86a8babf0ff00a86a7f6e35d16a9a476ff7ffef"
  end

  # No relocation, the localstatedir to find configs etc is compiled into the program
  pour_bottle? only_if: :default_prefix

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libseccomp"
  depends_on :linux
  depends_on "squashfs"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --without-suid
      -P release-stripped
      -v
    ]
    ENV.O0
    system "./mconfig", *args
    cd "./builddir" do
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match(/There are [0-9]+ container file/, shell_output("#{bin}/apptainer cache list"))
    # This does not work inside older github runners, but for a simple quick check, run:
    # singularity exec library://alpine cat /etc/alpine-release
  end
end
