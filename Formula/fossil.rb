class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.21/fossil-src-2.21.tar.gz"
  sha256 "195faf0b20c101834a809979d0a9cdf04a0dcbae1fdabae792c9db900b73bda0"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "489696cec14a8b890c82fcb70080f6559b4cd54b93e8bca8c2a7bdcbf1654389"
    sha256 cellar: :any,                 arm64_monterey: "4975c2fd99e11502110ae4024bdffdd9242e5c28dbf2dbb81230f862e767abf8"
    sha256 cellar: :any,                 arm64_big_sur:  "25f6b8aeb5dc6a491b1265c76972d33004344002afeb8ad3afd1a7c6a2922f7e"
    sha256 cellar: :any,                 ventura:        "4d33e22f97093471af81d86b603f24493192c68aa906a9f4cf8f8f3b28e0cadb"
    sha256 cellar: :any,                 monterey:       "cfe7d9af2c80fa8ae7e03c2049c819e6a29614b7bd901630ed4952118fbca574"
    sha256 cellar: :any,                 big_sur:        "83b2803eb21f8f1a968b9cebed1a047f5d2576d651b1f28717313cdfa04b0a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31fd06a80a96da70e1357996c816f0e9d33a06404277d103454ee58a48a50b24"
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
