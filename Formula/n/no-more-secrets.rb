class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v1.0.1.tar.gz"
  sha256 "4422e59bb3cf62bca3c73d1fdae771b83aab686cd044f73fe14b1b9c2af1cb1b"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bdce162d45e3059543b396e4eda6481e47ec9dc3b44e9a8d439262bdcd8fb20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66520c02cdeb6c76be9f7e64353b63950e3c017ebfeb475a18c87c3b51a380d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64fc527581550370d00962142f47e30d3e529e3462d72ababff155b5a13cd73d"
    sha256 cellar: :any_skip_relocation, ventura:        "a57a747b6547cf76a13b052417fdc76dd0f7ee5dcba5bfdf80720ba04d3adf5d"
    sha256 cellar: :any_skip_relocation, monterey:       "c8816e4e12990323c34330634bed74f02ebd03c05c666bfd175b50b037b1fda2"
    sha256 cellar: :any_skip_relocation, big_sur:        "40bfaa531207bce7140398180d44632f1f8574f720295061fb97bfdd14533a3a"
    sha256 cellar: :any_skip_relocation, catalina:       "badc69153ed6a345eff5282d2ce746395d0d04003ba29c096204c39633c7da06"
    sha256 cellar: :any_skip_relocation, mojave:         "05abb8f3a139e05d602efa4e14b5dc108f4be477330955523f3a3b2673d8ca13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6957194726eb655233552a996c4bb2dc8bae487ee8d4921de039def07118a94a"
  end

  def install
    system "make", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_equal "nms version #{version}", shell_output("#{bin}/nms -v").chomp
  end
end
