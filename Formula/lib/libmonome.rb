class Libmonome < Formula
  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/refs/tags/v1.4.7.tar.gz"
  sha256 "fb84198556623d0781efbd5f1dd2132594d6a86021043713995d06db4b2ef9ac"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50f7458c3bb329d5a42369d4e6a225f539b053589021324722cffdfc299ebdc1"
    sha256 cellar: :any,                 arm64_ventura:  "51b270c3e2424d2a9f139f89c0b928884a65a6553a96c88f6a2714ed386db4f4"
    sha256 cellar: :any,                 arm64_monterey: "80ed33d9b675b1e28ba7edc6ec3dfdcc9b917aaa54c66917f7af2d34a5f9c522"
    sha256 cellar: :any,                 sonoma:         "832ff6c908c972f83f87436442934610b13560348fa5305e992bf6c665fb40c4"
    sha256 cellar: :any,                 ventura:        "68ada8b140b2bd0da7f83ed38b78f36d273f4f5047b0880b4b1104bb52b2426a"
    sha256 cellar: :any,                 monterey:       "5aac1053b88e0c2f755962b2d83aac07c1bac36f7b501b07a7365f91d6a8b686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4215e99a9570308489a1c16672809b387f9c2b251b285fa9b6b1ba9967987f41"
  end

  depends_on "liblo"

  uses_from_macos "python" => :build

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    assert_match "failed to open", shell_output("#{bin}/monomeserial", 1)
  end
end
