class PythonS3transfer < Formula
  desc "Amazon S3 Transfer Manager for Python"
  homepage "https://github.com/boto/s3transfer"
  url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
  sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02f3305faf7504cd22c121ef3439cba50baae527f6f459f7c875da712600ec8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88ae3407a07c8b31c657113b100f49dd95500f662efe93ac0fa97b88dc061b88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d98f8c312f9ade4d4ece01549b58c89604a9849435228f0376e52d7a8dfce62"
    sha256 cellar: :any_skip_relocation, sonoma:         "13f1eba41f1bdcc6b03198a0efa1d52e774579c540c41071aa1c2a5193d67e2b"
    sha256 cellar: :any_skip_relocation, ventura:        "8d96b0f2cd9fff7c1a6e6f19a598fde538ec9688c3e7c2d8053f0e80ddea04ad"
    sha256 cellar: :any_skip_relocation, monterey:       "530cfb5e55bcc3b27bf8f51a3dd9fd5a7ff774275fc5979cb91aa38e8b000a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a486e92dd90450a77bccf2c66a3fa92ee5509ec06227d14e3c6e56c825314a"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-botocore"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from s3transfer.manager import TransferManager"
    end
  end
end
