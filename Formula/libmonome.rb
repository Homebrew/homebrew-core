class Libmonome < Formula
  include Language::Python::Shebang

  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.6.tar.gz"
  sha256 "dbb886eacb465ea893465beb7b5ed8340ae77c25b24098ab36abcb69976ef748"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bda08cc1624e2e73d7689d6c0e67ee1db9710ca9b07e6b30f68ee597e7c9e381"
    sha256 cellar: :any,                 arm64_big_sur:  "a7ad0fdf9885518b8924fefcfc865eeab54a41baa72f26aa6bb5708dea1a3e08"
    sha256 cellar: :any,                 monterey:       "32a37f45e31690d3fc2f1b5458c54e06e4f99f56f498fa8d800d47e0b08f5d53"
    sha256 cellar: :any,                 big_sur:        "1b101119d4a04e2bf678cc84f1ea69f1bd073b04f85f92d0ec7ba6d7e60d2bb8"
    sha256 cellar: :any,                 catalina:       "5d0c42d1a5796e00a46433dae63e4647ae17367e54b7be7e0cd5dbe5fbba86a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f89d4a6067bcf5980280cea1ea3b9cceccccefc4c043a23f27c79a78aea1aca"
  end

  depends_on "python@3.10" => :build
  depends_on "liblo"

  def install
    rewrite_shebang detected_python_shebang, *Dir.glob("**/{waf,wscript}")

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    assert_match "failed to open", shell_output("#{bin}/monomeserial", 1)
  end
end
