class Aws2Wrap < Formula
  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/db/07/db4c98b4d44ee824ad21563910d198f0da2561a6c7cfeaef1b954979c5c6/aws2-wrap-1.3.1.tar.gz"
  sha256 "cfaee18e42f538208537c259a020263a856923520d06097e66f0e41ef404cae7"
  license "GPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "793be218f866d4a783f0ca49b32515c3be383e94c2f95386ae07338e6ace0de4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2500d4adce97d108fc21ed3f927a19a666781d136bbf85228c77c8c40bf36a10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6007a99818a879b786fae8a01954cf4353e92c3a7fbc16f062f0139380baf26"
    sha256 cellar: :any_skip_relocation, sonoma:         "01279c6812af7aca180c3a6e4e3df527d662437ce04ecb87e0db5cac17d93ef4"
    sha256 cellar: :any_skip_relocation, ventura:        "73eecd11ab6bb700c0622592ba1401da33a0c3ddf597ad3c906fcceb91dd3460"
    sha256 cellar: :any_skip_relocation, monterey:       "6da87f5f87544ddd1cbfd54d563ebe8b201b45596068ca3d30825231008a578b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81966dff8907d3f9deef2f78a96119cd6bf4be9db9dd03ee414b542d542b5daf"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-psutil"
  depends_on "python@3.12"

  def python3
    which("python3.12")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    mkdir testpath/".aws"
    touch testpath/".aws/config"
    ENV["AWS_CONFIG_FILE"] = testpath/".aws/config"
    assert_match "Cannot find profile 'default'",
      shell_output("#{bin}/aws2-wrap 2>&1", 1).strip
  end
end
