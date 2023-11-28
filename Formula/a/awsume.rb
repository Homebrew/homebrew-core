class Awsume < Formula
  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://awsu.me"
  url "https://files.pythonhosted.org/packages/2f/d4/2f9621851aa22e06b0242d1c5dc2fbeb6267d5beca92c0adf875438793c2/awsume-4.5.3.tar.gz"
  sha256 "e94cc4c1d0f3cc0db8270572e2880c0641ce14cf226355bf42440b726bf453ef"
  license "MIT"
  revision 3
  head "https://github.com/trek10inc/awsume.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a81ac39e8c197e5ed36534cfc23f573e40775aa824f0bd450f8e381441cf95ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "300eeaf0ad9e1ca207ee6d464d9c0b640a45f93fd32257909d98c2f87d599407"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fb70bd9e57d6b27c746c731b60ce4dcc6639ddf253d5fb615f4c74e58c1d315"
    sha256 cellar: :any_skip_relocation, sonoma:         "939613eb6cb25804176e03e4c4e169c55d9f8f1beeba6fb5bc082df7c9446a63"
    sha256 cellar: :any_skip_relocation, ventura:        "e2784202d8aad654b710cd1b3e4e2641bb1afe218d064c4939f92037fda7e080"
    sha256 cellar: :any_skip_relocation, monterey:       "a3025b59faeaae4254f48523e8c3fb436b2013fd6d1192f606020cefe2e94f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d20e0464b529558106606be9e9460c4adfeade68f7d0a5464c2a9ebaad7fe915"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-boto3"
  depends_on "python-colorama"
  depends_on "python-pluggy"
  depends_on "python-psutil"
  depends_on "python@3.12"
  depends_on "pyyaml"

  uses_from_macos "sqlite"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match version.to_s, shell_output("bash -c '. #{bin}/awsume -v 2>&1'")

    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  ACCOUNT",
                 shell_output("bash -c '. #{bin}/awsume --list-profiles 2>&1'")
  end
end
