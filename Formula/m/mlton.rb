class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20241230/mlton-20241230.src.tgz"
  version "20241230"
  sha256 "cd170218f67b76c3fcb4d487ba8841518babcebb41e4702074668e61156ca6f6"
  license "HPND"
  version_scheme 1
  head "https://github.com/MLton/mlton.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/mlton[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)[._-]src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e4ab226d1c19700cfb7336f58945cffa425aa1a8e1efdbc661a34434be2ef571"
    sha256 cellar: :any,                 arm64_sonoma:  "27c4f97455e26387cee36bdba2faa5df88b69a80b385a74735b1631c6b7f1592"
    sha256 cellar: :any,                 arm64_ventura: "bed247cd0a0a8e1d219a0aa227bc0c1521546c982d6e39252471ca9788037702"
    sha256 cellar: :any,                 sonoma:        "6d43cf4850c6254329c6a4c1ee06f6e860bf133fca2772eac31c9d8f9e1645dd"
    sha256 cellar: :any,                 ventura:       "de3736436eba0b0a13c9f5c04dc472912366b1ab4aafce7c88d0b0b7687d1fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed7629b2e4edf19250fc7c6311fbf582b2f8b63658b3e8dd37083ceb98c8a801"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    on_macos do
      # See https://projects.laas.fr/tina/howto-arm64-darwin.html and
      # https://projects.laas.fr/tina/software.php
      # macos-15 is arm runner
      on_arm do
        url "https://github.com/MLton/mlton/releases/download/on-20241230-release/mlton-20241230-1.arm64-darwin.macos-15_gmp-static.tgz"
        sha256 "c6114fda99458cffe66cbcf508db65673926d0ac7ab707c3fc39a7efd563f74f"
      end
      # https://github.com/Homebrew/homebrew-core/pull/58438#issuecomment-665375929
      # new `mlton-20241230-1.amd64-darwin.macos-13_gmp-static.tgz` artifact
      # used here for bootstrapping all homebrew versions
      # macos-13 is intel runner
      on_intel do
        url "https://github.com/MLton/mlton/releases/download/on-20241230-release/mlton-20241230-1.amd64-darwin.macos-13_gmp-static.tgz"
        sha256 "7d6d21aa3ad651ccbe3c837c5876f5af811881fbb017d673deaedfd99b713a2d"
      end
    end

    on_linux do
      url "https://github.com/MLton/mlton/releases/download/on-20241230-release/mlton-20241230-1.amd64-linux.ubuntu-24.04_glibc2.39.tgz"
      sha256 "95d5e78c77161aeefb2cff562fabd30ba1678338713c50147e5000f9ba481593"
    end
  end

  def install
    # Install the corresponding upstream binary release to 'bootstrap'.
    bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage do
      args = %W[
        WITH_GMP_DIR=#{Formula["gmp"].opt_prefix}
        PREFIX=#{bootstrap}
        MAN_PREFIX_EXTRA=/share
      ]
      system "make", *(args + ["install"])
    end
    ENV.prepend_path "PATH", bootstrap/"bin"

    # Support parallel builds (https://github.com/MLton/mlton/issues/132)
    ENV.deparallelize
    args = %W[
      WITH_GMP_DIR=#{Formula["gmp"].opt_prefix}
      DESTDIR=
      PREFIX=#{prefix}
      MAN_PREFIX_EXTRA=/share
    ]
    args << "OLD_MLTON_COMPILE_ARGS=-link-opt '-no-pie'" if OS.linux?
    system "make", *(args + ["all"])
    system "make", *(args + ["install"])
  end

  test do
    (testpath/"hello.sml").write <<~'EOS'
      val () = print "Hello, Homebrew!\n"
    EOS
    system bin/"mlton", "hello.sml"
    assert_equal "Hello, Homebrew!\n", `./hello`
  end
end
