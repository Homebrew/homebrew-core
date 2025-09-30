class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/neocturne/fastd"
  license "BSD-2-Clause"
  head "https://github.com/neocturne/fastd.git", branch: "main"

  stable do
    url "https://github.com/neocturne/fastd/releases/download/v23/fastd-23.tar.xz"
    sha256 "dcab54485c79dda22ce6308a2a48764d53977a518952facd1204ba21af1c86e0"

    # remove in next release
    patch do
      url "https://github.com/neocturne/fastd/commit/89abc48e60e182f8d57e924df16acf33c6670a9b.patch?full_index=1"
      sha256 "7bcac7dc288961a34830ef0552e1f9985f1b818aa37978b281f542a26fb059b9"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9c8e775650403436785d0cdfc910c4266874951649102e80ab289ac810731789"
    sha256 cellar: :any, arm64_sequoia: "0e49dc056a65bd9665f96f384eff2843e3171ce178758cae06f8c2263a350511"
    sha256 cellar: :any, arm64_sonoma:  "71e35318e2053784ab994a73a4154ed20f9edbdc0d8f499a640b6acb9f2e304b"
    sha256 cellar: :any, arm64_ventura: "39736a2f0b8cbf6e57cb89b7f16ad59195007b8299c1b308815b5f053824df47"
    sha256 cellar: :any, sonoma:        "4b2b7cbd3c7cd14efeb200d2e2a75ce9b1fb15633fe323d486ef7da2739ae129"
    sha256 cellar: :any, ventura:       "d67909e9fba4d7f3accffe974b6142a0fe9e9c6bd8a661e4e20fc4b1ad0c01ec"
    sha256               arm64_linux:   "20cf70054b026b5303e4f4e20992fd1888750cd5261ab396083a830375d70d20"
    sha256               x86_64_linux:  "7578a78bec1555ad86e17cd3e88423093def42af998403fd316bbcf03d975789"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"
  depends_on "openssl@3"

  on_linux do
    depends_on "libcap"
    depends_on "libmnl"
  end

  def install
    system "meson", "setup", "build", "-Db_lto=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"fastd", "--generate-key"
  end
end
