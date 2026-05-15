class Apptainer < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https://apptainer.org/"
  url "https://github.com/apptainer/apptainer/releases/download/v1.5.0/apptainer-1.5.0.tar.gz"
  sha256 "36d67d57ef959397fa4f59169cf7deb92220537160e761e0c1cff84624ad81e3"
  license "BSD-3-Clause"
  head "https://github.com/apptainer/apptainer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "39e03d7e4b2e68548b73be60516fbcbe276fc62e03eca03346d15b4799873082"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bc38fe8a8b777da096ef715f64fd978b15b54196be745c1059791699d1cc76d4"
  end

  # No relocation, the localstatedir to find configs etc is compiled into the program
  pour_bottle? only_if: :default_prefix

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libseccomp"
  depends_on :linux
  depends_on "squashfs"

  def install
    ENV["CGO_ENABLED"] = "1" if Hardware::CPU.arm?

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --without-suid
      -P release
      -v
    ]
    ENV.O0
    system "./mconfig", *args
    cd "./builddir" do
      system "make"
      system "make", "install"
    end

    generate_completions_from_executable(bin/"apptainer", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/There are [0-9]+ container file/, shell_output("#{bin}/apptainer cache list"))
    # This does not work inside older github runners, but for a simple quick check, run:
    # singularity exec library://alpine cat /etc/alpine-release
  end
end
