class DashShell < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/dash-0.5.13.3.tar.gz"
  mirror "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.13.3.tar.gz"
  sha256 "a83727c1299ac4c3d9d43979393b3a4eb00275d5636ae02526e7979d51d6fbd1"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git", branch: "master"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65e1f9e282e54b309f98da5b920471b4dde8e1f7a16d30ea97aff9eeaf23003f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f9fa078bc85fc0ec14a431572dead40a38e8d43c19f66fd5abfaac6ff8b2ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a570c8f3c3d594ca585cfbe9d1c396463c5095d22fc30b8aec3512e1836ede1"
    sha256 cellar: :any_skip_relocation, sonoma:        "69d63acdc95189907326ae70aae49b7ead0d9872720f8d91dca0f10e4d58b006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aebd91e2ef38afab388ea46a50c25862f4522bdfa3eb1ff94d1bd915644cedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4fb8e6d7e162426021414329950aef5dfa0da7de0be5c4d3418e55b11dc0d3f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libedit"

  def install
    ENV["ac_cv_func_stat64"] = "no" if OS.mac? && Hardware::CPU.arm?
    system "./autogen.sh" if build.head?
    system "./configure", "--with-libedit", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dash", "-c", "echo Hello!"
  end
end
