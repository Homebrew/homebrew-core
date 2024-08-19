class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.8.13.tar.gz"
  sha256 "e2bde058d0d3bfe03e60a6eedef6a179991f5cc698d1bac01b64a86f5a8c17af"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd4ec6b5b5adec77841ece1dd42037ca2cb29e5a62112e5b830ef84ab95f0ccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f79ae91591571ac90eeddf5e774c4349899cd456b6c18eb1b2afb5ccb8285826"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70bcd972d9ac92d6f6ac7276bcfab123636a5c3916c012144f38f90e85a094c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "216a5f0e7f3ffb03e026d46b7b67d738fe82465df393f9bd7ad106d4d14873b7"
    sha256 cellar: :any_skip_relocation, ventura:        "08bc06b9652c2d9da09dff9e15187c2bf88a4cde172390a429285677f04af52b"
    sha256 cellar: :any_skip_relocation, monterey:       "039818f9f2196435e0cfe44846a03797cbdb09ba3435e5f7860598b2bf99dda3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ecc2417c4287ae63f9d81857aa9ecd007de8a0591594fe6dda28f15f237f895"
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
