class PyqtBuilder < Formula
  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/21/e9/5ee4d76d3f4c566b090924e36da067748db948a5faeff4142d149a4d5a15/PyQt-builder-1.15.3.tar.gz"
  sha256 "5b33e99edcb77d4a63a38605f4457a04cff4e254c771ed529ebc9589906ccdb1"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d93a15947d1061a6cf97569b7fae79c3c272313c4d8e85ad131d9a0baebe9792"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af0f61e288f00fd96b1bd0962387c0cea61d11a52d62457e69b71f82081c7d9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06be2d06cb34b32d2bdcbff24b3a237dddc7e3618671df1ca8dccb5862e8e9c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c191cce896cd8128abcfd74a528d15dd59e667afc8a7d6d20cec119732c68c78"
    sha256 cellar: :any_skip_relocation, ventura:        "1a6ce76309401aaff60574312d9eec0ae8e3d0dba89237336a9726e5f4869730"
    sha256 cellar: :any_skip_relocation, monterey:       "d02d83c34d10db832755116c852a9829352191ae5beed08aef15ce8c4e25e500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67a555c0f6971097fbeb140dc5bd01d16f576bf78d70b0e55d73a269e3366809"
  end

  depends_on "python@3.11"
  depends_on "sip"

  def python3
    "python3.11"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system python3, "-c", "import pyqtbuild"
  end
end
