class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "https://github.com/freeDiameter/freeDiameter"
  url "https://github.com/freeDiameter/freeDiameter/archive/refs/tags/1.6.0.tar.gz"
  sha256 "0bb4ed33ada0b57ab681d86ae3fe0e3a9ce95892f492c401cbb68a87ec1d47bc"
  license "BSD-3-Clause"
  head "https://github.com/freeDiameter/freeDiameter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "79b0aab464344c4db67cf04e06843db87e219a7b05d852b927d6fcd24cf3f7af"
    sha256                               arm64_sequoia: "b8c2fe00ccc13df0321b77ba8b9b8287c6de4639864b37fa1f4fc21fb4fe383b"
    sha256                               arm64_sonoma:  "97fc7352a5df11e743dd713984e3c40d80a0fec9f0a1ac6f77932be2f4edb129"
    sha256                               sonoma:        "339a7c3048eb764262f7cc21c6124b343073c1da9b8a17de666d538297679530"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dcd802cca540beb227ba97fe1f24e3e7bd2487613d2069090933c85da5b28b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3514c432b5aa213070d850934ff359f3caca1e1e04862e3ab215f676356f139"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDEFAULT_CONF_PATH=#{etc}
      -DDISABLE_SCTP=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cp "doc/freediameter.conf.sample", "freeDiameter.conf"
    etc.install "freeDiameter.conf"
    doc.install Dir["doc/*"]
    pkgshare.install "contrib"
  end

  def caveats
    <<~EOS
      To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

      Sample configuration files can be found in #{doc}.

      For more information about freeDiameter configuration options, read:
        http://www.freediameter.net/trac/wiki/Configuration

      Other potentially useful files can be found in #{opt_pkgshare}/contrib.
    EOS
  end

  service do
    run opt_bin/"freeDiameterd"
    keep_alive true
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end
