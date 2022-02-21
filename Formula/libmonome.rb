class Libmonome < Formula
  include Language::Python::Shebang

  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.5.tar.gz"
  sha256 "c7109014f47f451f7b86340c40a1a05ea5c48e8c97493b1d4c0102b9ee375cd4"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2586654c2f9381daadac953d61095d940846f889512ce10f6283455168df4168"
    sha256 cellar: :any,                 arm64_big_sur:  "10ae2ac1ad8c7f624c6ba80fab94052c34782c9098dc6eabf8c816249de8dbee"
    sha256 cellar: :any,                 monterey:       "dac24d8f2375102fc74f93793aea42f8c225498a2894533379c9da7084bb7e2e"
    sha256 cellar: :any,                 big_sur:        "bbe1beb15996bc7c3c859d0fe1cf1ff69a9a20d57d2e8d38a51ad6faecbf0477"
    sha256 cellar: :any,                 catalina:       "32a0477e5cd9eed622071336834054b2d94009f7a21a310d54ce38287682afd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d81c5610626ab005919bd687307dc00976becc2d7e7cc5bc58506466596fd5"
  end

  depends_on "python@3.10" => :build
  depends_on "liblo"

  def install
    # Fix build on Mojave
    # https://github.com/monome/libmonome/issues/62
    inreplace "wscript", /conf.env.append_unique.*-mmacosx-version-min=10.5.*/,
                         "pass"

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
