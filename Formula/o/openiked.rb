class Openiked < Formula
  desc "IKEv2 daemon - portable version of OpenBSD iked"
  homepage "https://openiked.org"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenIKED/openiked-7.4.tar.gz"
  mirror "https://mirror.edgecast.com/pub/OpenBSD/OpenIKED/openiked-7.4.tar.gz"
  sha256 "19b72b48080240c3eff585f5cbcf6aa7b5734192ad8bc6677ae64a455074358a"
  license "ISC"
  revision 1

  livecheck do
    url "https://cdn.openbsd.org/pub/OpenBSD/OpenIKED/"
    regex(/href=.*?openiked[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_golden_gate: "33bcb994c40956c0140f65381acad67ffdff557806bf3cd322bfa14f111d49d3"
    sha256               arm64_tahoe:       "4d2f7d979b3d054e50191123d8bd20d83339b9ff3a64f57d20dde48113ca57ec"
    sha256               arm64_sequoia:     "9ff8004892fc3038ba5a93f414d6744c83744afe218cbd7d667edfb932d3e733"
    sha256 cellar: :any, arm64_linux:       "ce154496a462c155c28b3fd48e0a514bb3f4ea423da90b95e275197b2526958e"
    sha256 cellar: :any, x86_64_linux:      "aa41747f65218e765c2e18c5ffcaed5b16ee22a9f208687704257d73a21b8ab9"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "openssl@4"

  uses_from_macos "bison"

  def install
    system "cmake", "-S", ".", "-B", "build",
                         "-DHOMEBREW=true",
                         "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                         "-DCMAKE_INSTALL_MANDIR=#{man}",
                         *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "build/regress/dh/dhtest"
  end

  service do
    run opt_sbin/"iked"
    keep_alive true
    require_root true
    working_dir etc
  end

  def caveats
    <<~EOS
      config file can be found here:
        #{etc}/iked.conf

      necessary files for configuration can be found here:
        #{etc}/iked/
    EOS
  end

  test do
    system sbin/"iked", "-V"
    system libexec/"dhtest"
  end
end
