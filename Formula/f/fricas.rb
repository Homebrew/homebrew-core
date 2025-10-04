class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.12.tar.gz"
  sha256 "f201cf62e3c971e8bafbc64349210fbdc8887fd1af07f09bdcb0190ed5880a90"
  license "BSD-3-Clause"
  head "https://github.com/fricas/fricas.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7c87044d00ac54aed75e3c74024198bfa1334da3cc66e378bb084e9bf34e8b2e"
    sha256 cellar: :any,                 arm64_sequoia: "6a4986f527a329cda2916c92b2065ae6d41aab08377bf751195b26a88036fd50"
    sha256 cellar: :any,                 arm64_sonoma:  "c254d2cb770eb7c6796fa9293b06d01c6ffb14be778254ab3a26fc17a8eb8bec"
    sha256 cellar: :any,                 sonoma:        "9b27da492022588d3d26575fa5f103bfe38f6102679fce800ac4ef9ce8e76343"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc084992d8a884fc40ab26b670100ea7aa8e83e91baabb22a9eac3e3687ae9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8412b5815cf0fa53cadd4b4608ba229c84aa50120023fe04279f4e19a9a83360"
  end

  depends_on "gmp"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"
  depends_on "zstd"

  on_linux do
    # Patchelf will corrupt the SBCL core which is appended to binary.
    on_arm do
      pour_bottle? only_if: :default_prefix
    end
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    args = [
      "--with-lisp=sbcl",
      "--enable-gmp",
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end

    # Work around patchelf corrupting the SBCL core which is appended to binary
    # TODO: Find a better way to handle this in brew, either automatically or via DSL
    if OS.linux? && build.bottle?
      cd lib/"fricas" do
        system "tar", "-czf", "target.tar.gz", "target"
        rm_r("target")
      end
    end
  end

  def post_install
    if (lib/"fricas/target.tar.gz").exist?
      cd lib/"fricas" do
        system "tar", "-xzf", "target.tar.gz"
        rm("target.tar.gz")
      end
    end
  end

  test do
    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output("#{bin}/fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end
