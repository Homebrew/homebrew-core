class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.26/fossil-src-2.26.tar.gz"
  sha256 "a9be104c8055ada40985a158392d73f3c84829accb5b5d404e361fea360774c2"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256                               arm64_sequoia: "cd0afa8139ae0456e601ad865e25f0d3165469c8ccc0b5fddfa2c21636d90a1d"
    sha256                               arm64_sonoma:  "5506de25e925a7a39d02a3f9876928345ec5b2f585f75838a6c103d321179027"
    sha256                               arm64_ventura: "cbe71ce1e8b2c5cb0b27eca0521484516c4ae9636e0c8faa8f298ffeabd4fa4a"
    sha256 cellar: :any,                 sonoma:        "825f9d44387eb478bf92676dfdb41a7b69c9fb18ba500bee6ce959780de3cdb7"
    sha256 cellar: :any,                 ventura:       "3753125d37530b20b83ce56f640ac28ce2137861d41d9e68afd3c8bae3b0ced6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d58255ab2f19eb5bd97f3c06102be0b4be57f814ae22ddccf7de5fafad0a6202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d7b9343231a9fc18fd03128b5e5d1af97104af6a8f839d247760117c34e7cd9"
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
