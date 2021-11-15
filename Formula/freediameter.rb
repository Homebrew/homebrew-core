class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "http://www.freediameter.net"
  url "http://www.freediameter.net/hg/freeDiameter/archive/1.5.0.tar.gz"
  sha256 "2500f75b70d428ea75dd25eedcdddf8fb6a8ea809b02c82bf5e35fe206cbbcbc"
  license "BSD-3-Clause"
  head "http://www.freediameter.net/hg/freeDiameter", using: :hg

  livecheck do
    url "http://www.freediameter.net/hg/freeDiameter/json-tags"
    regex(/["']tag["']:\s*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "ef01b2ee94b8f7b8794b6880188ec09d7a8458b0e10a2b6063b4dcc0f9b7c798"
    sha256 cellar: :any, arm64_big_sur:  "a2fd2271af79fd86ec7162e0af3adbaf611f280563a84dc2a98af96b7b3a3a4d"
    sha256 cellar: :any, monterey:       "506a0a7375314a874e8a04b4904d0fe9d7c83bda4c494171c4ceee242debd81d"
    sha256 cellar: :any, big_sur:        "2c99cc840e0daebf52793d55e91ec616416c7fc7c4f4a8c332c6fe8c52fd181d"
    sha256 cellar: :any, catalina:       "92933b4a5076f85098b784f47f3943065444b9dda243c6165d38aaffb9122b68"
    sha256 cellar: :any, mojave:         "3d5aa2577193d90113f4deadd81c6db0b40384a4cf3cca096e6edeb76ee734e3"
    sha256 cellar: :any, high_sierra:    "a242566b7096b737a094ebe7c792fe306ab6f06f28cded3b5c6660962b812610"
  end

  depends_on "cmake" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DDEFAULT_CONF_PATH=#{etc}",
                      "-DDISABLE_SCTP=ON"
      system "make"
      system "make", "install"
    end

    doc.install Dir["doc/*"]
    pkgshare.install "contrib"
  end

  def post_install
    return if File.exist?(etc/"freeDiameter.conf")

    cp doc/"freediameter.conf.sample", etc/"freeDiameter.conf"
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

  plist_options startup: true

  service do
    run opt_bin/"freeDiameterd"
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end
