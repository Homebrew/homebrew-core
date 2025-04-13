class Apptainer < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https://apptainer.org/"
  url "https://github.com/apptainer/apptainer/releases/download/v1.4.0/apptainer-1.4.0.tar.gz"
  sha256 "204cded54046547cb3eb4c7874bdf45892fedc58b0d104195c59d2972cba51d3"
  license "BSD-3-Clause"
  head "https://github.com/apptainer/apptainer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "707d8a374a4897030f9a8385da58c049f00e70c154ddf37c3325aa92964ada98"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ec8f93b5d4c7f8d46594ea260334d59130a0c8bd68b2ca64950599fdc90088d8"
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
