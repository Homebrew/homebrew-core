class Jr < Formula
  desc "CLI program that helps you to create quality random data for your applications"
  homepage "https://jrnd.io/"
  url "https://github.com/ugol/jr/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "30e431bbce6382f49d555028e6120c394580f74f81b46022f18890d5bd379963"
  license "MIT"
  head "https://github.com/ugol/jr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47049f7c69353b8a0d1d24ae93a97bf0e2b015eaffebcf1e16e5d2d27caf55cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb347769c407a1d6dba4a65a425ac2f0483c56a409b81252448e2e69ab2c4730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "769244d46167d4674723bc7cbcd63599e11db71bca6024d5061127d7508e1e5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "74360526509b49c6d64ce8064d41b781cd3d318d8cbd1640847aef6c50f137f2"
    sha256 cellar: :any_skip_relocation, ventura:        "a63c3698f0dff8e22af5150fc7ac062eed53be89e966099840d98c9ebbe53e26"
    sha256 cellar: :any_skip_relocation, monterey:       "59f4c3da1a54c1624ee6ea5e1d8cc71fdc8cc1c6b70295183745147cd0426bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f05b6086246a5a95a5421fa7008be84dbb36a6dccb9904f54cb0b221f59ea3"
  end

  depends_on "go" => :build

  def install
    system "make", "all"
    libexec.install Dir["build/*"]
    pkgetc.install "config/jrconfig.json"
    pkgetc.install "templates"
    (bin/"jr").write_env_script libexec/"jr", JR_HOME: pkgetc
  end

  test do
    assert_match "net_device", shell_output("#{bin}/jr template list").strip
  end
end
