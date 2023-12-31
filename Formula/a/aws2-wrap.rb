class Aws2Wrap < Formula
  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/6d/c7/8afdf4d0c7c6e2072c73a0150f9789445af33381a611d33333f4c9bf1ef6/aws2-wrap-1.4.0.tar.gz"
  sha256 "77613ae13423a6407e79760bdd35843ddd128612672a0ad3a934ecade76aa7fc"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8b374bd5ca1b8074e9d54b6361f7544fe6319b73fcf8588cb140e9f82bf3741"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d12dc6608b564e80e84c4b664e3ae256af137e3123af9fff94dadc64a4d4a48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dd477a77f4f55fc138334f8abba465d7dd28da79c540622ccc5349741e5e1b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "98c3104dceb89ef1d80d98de8a3a44b5fab873a43aefd3cce46393f178939e72"
    sha256 cellar: :any_skip_relocation, ventura:        "55e41f9bcb2c8c2bd198e7c8ce7f9148c4c1dd158ae9f25e1d425acfc92d5edc"
    sha256 cellar: :any_skip_relocation, monterey:       "74824c7473fe292a9dec7c2a7aa56c918fb1b431e17dc849bd4a5dc191031ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb70ff1309f1eef3bbadfaf1a893005c441c5fea2ca7b689c02b1b4b7ed522c"
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
