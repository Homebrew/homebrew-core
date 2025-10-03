class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.27/fossil-src-2.27.tar.gz"
  sha256 "0405a96ba4d286b46fb5c3217d6c13391a2c637da90c51a927ee0c31c58f9064"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "a40eef34a5a75926ba5bd5565e55e8c8516194d576fc0db185643d2cd53dcce8"
    sha256                               arm64_sequoia: "890c782065554f55d8bc3b4ed9893ce6653e3071f42b7d54f5ea0b1d10888600"
    sha256                               arm64_sonoma:  "20926d9e74f6446c82dfe6ff2c7e43bf2cda953e04ed80c1e79a1eaffcdae853"
    sha256 cellar: :any,                 sonoma:        "17864aa860d64edd0294947b0992a2bbcf944f83bd61f9d431da2c0bab7bd4e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1e7e5e722632e97a05afac0be97279fd9c7aec985d036ac60ec741acacb5f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751ab9ed504db45228457a763eba4ae27b70d825b5a851a55f644e23978c18e4"
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

    args << if OS.mac? && MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
    bash_completion.install "tools/fossil-autocomplete.bash" => "fossil"
    zsh_completion.install "tools/fossil-autocomplete.zsh" => "_fossil"
  end

  test do
    system bin/"fossil", "init", "test"
  end
end
