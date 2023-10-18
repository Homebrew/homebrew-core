class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.22/fossil-src-2.22.tar.gz"
  sha256 "b90c40beb75308b0eba46b5add6e54a7a9e65ac90ce86ec8d78ae2a4bb8bae60"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b9867dc0b641c8fc86cd173a76db3e95080ea8d01b38efcfaab88c3a44f8b672"
    sha256 cellar: :any,                 arm64_ventura:  "b94ce3001a82290ee588c9499343db618813a6adafd6b8c43db2b450235940b9"
    sha256 cellar: :any,                 arm64_monterey: "63c03e0f8f94c3fd55cf749efd9a2285232c9565f46bfc5e2a6196778be08eb0"
    sha256 cellar: :any,                 arm64_big_sur:  "1b7f99cf2957c1d81fea04817297f0bd5e61c6f82508a750a9b020dd7ed8ca33"
    sha256 cellar: :any,                 sonoma:         "597adb1707b522c79fb3a36160180b70cb3a93c5231aff234a59690d0922529c"
    sha256 cellar: :any,                 ventura:        "ef4f5d8a5288586ed014f6b9c74b25b7314fe831dfb81023e2c4a44562217ed4"
    sha256 cellar: :any,                 monterey:       "0b86c60fe15c069e91af5c67eefedbbfbb1933b75efef5ee567bdfc29f856e90"
    sha256 cellar: :any,                 big_sur:        "a5614d61bfb0a2ab2cfc52f09d2eb6fbd5378ab4e02c5b5b71bfc533844cf83d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e5942acbd93788b9cc50b221d66b266b3f6d2532eeedfdcf4cb4c795f976d4"
  end

  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
    bash_completion.install "tools/fossil-autocomplete.bash"
    zsh_completion.install "tools/fossil-autocomplete.zsh" => "_fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
