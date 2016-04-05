class Editorconfig < Formula
  desc "Maintain consistent coding style between multiple editors"
  homepage "http://editorconfig.org"
  url "https://downloads.sourceforge.net/project/editorconfig/EditorConfig-C-Core/0.12.1/source/editorconfig-core-c-0.12.1.tar.gz"
  sha256 "aa9cd57382c883f1be7b6c3470094317e4d3e64175a376ea49326987055153b8"
  head "https://github.com/editorconfig/editorconfig-core-c.git"

  bottle do
    cellar :any
    sha256 "8701378252f11b3ace91a48addc5c9a93e264b5f5a2d7be60082713a53f2f43d" => :mavericks
    sha256 "3dbc17ab5abf697ea8d4cde6bc896b2bba5d89058983e3688755c288b96fbeec" => :mountain_lion
    sha256 "b6b87de9eedcd1a292ac32c5a100cb555548729e73d5a41e1854f0610dffe746" => :lion
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "pcre"

  def install
    ENV.universal_binary if build.universal?

    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
