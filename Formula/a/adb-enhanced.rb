class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/18/3e/8bf74e86f1821d190260e01b7a8efb615ad17f2e247c592df89740141cb5/adb_enhanced-2.8.0.tar.gz"
  sha256 "75c92007bbf295ec97fb89fedf0bd24e6424d726b1343aa3b1fbf5e2115efcc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1263d7bafc377a908cf3db5e8f66cbce9162a7b7c5828b66430d1448820c5552"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56d8425f29c678d6a9e514886f9dcc54a924a9ef589fa9d3a3d6dc2c638793c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c62b3fa8bfa4e99547f8ae205f6641e5e0a860a27ac21a3a368d919bebde178c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e8b2216dbe459c43fc5e995834fd75a0e2e67c9eabcd620454cda596aed9150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb5554a9273161147c22318202c5bfc2fe751d8eccc2593e71d60a5b2c9be6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22a6b1e9ab9a4c2401ffa5ed3b0bf0704c920932f5a2598734be8c3f5373d6ad"
  end

  depends_on "python@3.14"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end
