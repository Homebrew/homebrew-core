class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/home/"
  url "https://fossil-scm.org/home/tarball/version-2.25/fossil-src-2.25.tar.gz"
  sha256 "611cfa50d08899eb993a5f475f988b4512366cded82688c906cf913e5191b525"
  license "BSD-2-Clause"
  head "https://www.fossil-scm.org/", using: :fossil

  livecheck do
    url "https://www.fossil-scm.org/home/uv/download.js"
    regex(/"title":\s*?"Version (\d+(?:\.\d+)+)\s*?\(/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "f940b00bf67d72bcaa308d65d0dd4d0000050c9e6350c1cdf5af3abef3eb0df5"
    sha256 cellar: :any,                 arm64_sonoma:  "485d99c94ad1b983c067b58ec598de0a4c7435e1b6a3d4a8d0ff9c87acd502dc"
    sha256 cellar: :any,                 arm64_ventura: "445d83ebc19a1c94688312fa0644c214bd9dad8d229d8137942ccf1c8a2b6ff7"
    sha256 cellar: :any,                 sonoma:        "da30f15f9e8bbbb71bb266227f7751184716a83a47758fcd161128104ca1fa6d"
    sha256 cellar: :any,                 ventura:       "66e7fbc96d8345dfca174a13c82074637ff3a48c28263d2b647d63252d498633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0d70b16f182fe16b689136b61fd541030baaa1b633f996cb1e63a0f4b08eda8"
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
