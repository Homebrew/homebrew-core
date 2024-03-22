class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.8.5.tar.gz"
  sha256 "d22948d06be06a5be37336318de540a2215be10ab0163f8cd23a20149647b780"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3db10a9abb275ad0b5d20a3dd86765262adc07a555fb396f9d925527c64bd0a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac85c468493142c8ae4f78999a2385fb9437e761bf2a3d33563d974eb9ef6f22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b75071fbe24e93a6bfa518caac36f13f5a2ec7b6f61b5d7a02691903480f796"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb686593f872b76e58c168aa4cbf76428b5fedc166cbcfeeb379648007801959"
    sha256 cellar: :any_skip_relocation, ventura:        "479fdd8cf09f578aaf87f599c67610a89872f13dbc727bbe960ee9541708c2f7"
    sha256 cellar: :any_skip_relocation, monterey:       "64f4d67c0c61e219f9026b723fe4e759671a0b8d8a3c99400a8c2b859b6b2772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38fdc38a06a97769bd67824c2f102cee6cf31e761746ac415631208c7ce8932b"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
