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
    rebuild 2
    sha256                               arm64_tahoe:   "6101f02874dba7633196889ea14e9d5d397d8ec51d1c47f603d15413cb2ef6eb"
    sha256                               arm64_sequoia: "dd54ac49636ecf8491ed2219ea3e8bc10fc1f0b29ac5f7125e5dfea54e2ac020"
    sha256                               arm64_sonoma:  "0315d7812c32d103ddd734fcc28e80ad6b0ae947b6d672af24d4cf16990e3f2e"
    sha256                               sonoma:        "1a07c7755a97e4d8e35bf575330316ab84b260d265205c963deb719d828a7dc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e8a5d5d8e5e831dbd4fd69a673c44828e663a96edbbf1c8da9178cf2c0ea62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "217a7b1ac6a2719401fc8978f58b46e68f4daabe4e0d6dd4f21f950903581e9b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  # cmake rpath patch, upstream pr ref, https://github.com/freeDiameter/freeDiameter/pull/84
  patch do
    url "https://github.com/freeDiameter/freeDiameter/commit/3037ee7735b969d106b197818c1a5bcdb4586d77.patch?full_index=1"
    sha256 "146a8e6586b1a1146f06771129609583d43a792bbd94eea7a3c0348f02eb26b2"
  end

  def install
    args = %W[
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
