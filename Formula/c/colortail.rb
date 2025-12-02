class Colortail < Formula
  desc "Like tail(1), but with various colors for specified output"
  homepage "https://github.com/joakim666/colortail"
  url "https://github.com/joakim666/colortail/releases/download/0.3.5/colortail-0.3.5.tar.gz"
  sha256 "8d259560c6f4a4aaf1f4bbdb2b62d3e1053e7e19fefad7de322131b7e80e294d"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9862416bf5401f2a2a61f90bdac87795f7445e95cf4baf6e0d0d73e984740a99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46881ac8087481d7f575b911883807e424a02ab942a7af58d9c38b4d2b73ef85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51277f3ef27c9d547f2f07a3e81cfddb744b1e1a566e6e020c5c9a92f804f5f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e6f802573fbe0d69c824e53529faf6e89703247cc1a99e0889c8ac04bb731b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c5d498dedf3d26bf0636d10e5a82bdda798dbb480f89ab07a19fdc75159053a"
    sha256 cellar: :any_skip_relocation, ventura:       "2b9245f09d0796f87a0e4d615631bd7a678135dc25d5243128b8c47104bae3aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78b490e972fd2d3c0b3f1a1975bdd221f61e990caf05acd383bf5a79ef675a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7f6aa1cfcfd61cef470944acee240c93f2442639355dea39fe06e414d168cab"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello\nWorld!\n"
    assert_match(/World!/, shell_output("#{bin}/colortail -n 1 test.txt"))
  end
end
