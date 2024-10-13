class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.8.14.tar.gz"
  sha256 "0cc18811a4809a587d4b11d47691bbc0ad83a5d95d2c2606af74ea7b4a674756"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ac34bbb8c78a13fbca713ee5031bb805f9552f73b10b5668e264f8ea8716f89b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "843ff02fb9d0a82329ac69bfff73292550c49597627391b8eb03586bb106a60a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a2b3d0d5934b8cc71c10fbdd8329db79fb4dc7f376c46a6516c3211ba5ba04e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cb740dc49bca09d096f0e9b6687ddb6cefcb91757483771a6b9076f39cbdc2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8555f370ca741ce3976cf0a02f52a6e337c029b777d7345217c52f15bee6e6fd"
    sha256 cellar: :any_skip_relocation, ventura:        "ef9e38140617294b5a9d9df2dbef389d7a012ec81466bb6163a4c6e1461a5f6e"
    sha256 cellar: :any_skip_relocation, monterey:       "1bddb846e27f961bbb282043ed09896681a7f0e0a23b372c27d3cbbe3539ef1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e874b9ba6c1ae8f7844349e8d3b4e6d0681a665fbdf5b4d83d520747e63220e6"
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
