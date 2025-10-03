class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/refs/tags/0.33.9.tar.gz"
  sha256 "310823bb3437b2a9ce8979a31951405e057fa2f387ef176b64ef3ce3041f59d0"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1eab9c210e11a5589cff8a1b39a8e59e26c05b20c8f3f4b3bc89443eed898c21"
    sha256 cellar: :any,                 arm64_sequoia: "3104c10993ec9f6fa2d991ccdfccca6f0166cdf092bcd46c59698ed4683fef92"
    sha256 cellar: :any,                 arm64_sonoma:  "0253b805259079f8bf8b404bd5614a77daad653fb18893f71074710683515fd1"
    sha256 cellar: :any,                 arm64_ventura: "27a31a5719db34d087da2fc6832ceebb9ccda45b56165b3210f2a29fbc113c51"
    sha256 cellar: :any,                 sonoma:        "3552da06ec87afbda580f929ca26090d3e119a8e5ede5405ec14f3908f0f0e95"
    sha256 cellar: :any,                 ventura:       "f78d17b46c361affea770eb947415dc85d1b0790021b351b326e097ae59130e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d379f0883d1d731656ee060a7ada6554e61869522df8586f98c114d16228ce81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21c07a02ff6d5e575114a724084a05dc61257f4ae3fbd81c2f7e33e35b190b28"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.13"
  depends_on "readline"

  on_linux do
    depends_on "acl"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_path_exists testpath/".bup"
  end
end
