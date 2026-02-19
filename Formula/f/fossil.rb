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
    rebuild 1
    sha256                               arm64_tahoe:   "7e094477bb5602aca979d117cf3ffad1fc51aeda6b5dbbbbaa1cdc34b6a1b34d"
    sha256                               arm64_sequoia: "9392007c863be3dc16c5820330ae782c8dd425866b06be064592fa1ae8108deb"
    sha256                               arm64_sonoma:  "c2f8ede6e38cfb7c73f5a7b10b2f205b35b14a009eda087356ee561104d7407e"
    sha256 cellar: :any,                 sonoma:        "5f4e26e48b7bc9389167e1af70ba8272fda1670143f26eafecd047acb0b9a517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ffc405ac2b1467360a672fea2a8f1bcd1906fcfbba351010a2205a77f51c6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d02265c632ed51ce08808abaf7a9171e7173143eeddac0e02f944044e5108a8"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
