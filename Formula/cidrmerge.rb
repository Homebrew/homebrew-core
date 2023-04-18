class Cidrmerge < Formula
  desc "CIDR merging with network exclusion"
  homepage "https://cidrmerge.sourceforge.io"
  url "https://downloads.sourceforge.net/project/cidrmerge/cidrmerge/cidrmerge-1.5.3/cidrmerge-1.5.3.tar.gz"
  sha256 "21b36fc8004d4fc4edae71dfaf1209d3b7c8f8f282d1a582771c43522d84f088"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66c685d8c347fd583afe154475091c456ec7c9e7f0891542fbe1a46bebfad216"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1917c09d7f9dd006a7688c9be3e1673c3a93950f9e58d23eb6b2dab14b2a334f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49083b84e43debb1921bf1e3788dd5614bcbac3d70b68d099734421fa94f7fd5"
    sha256 cellar: :any_skip_relocation, ventura:        "ec886d391031fb25d40a8430fb5a73e07b7c8cfb33963ec78ad10cf13dceb0fe"
    sha256 cellar: :any_skip_relocation, monterey:       "a447eb73e2385698470c99081afdc04f33f15ad684573828f2e8531eb7a84786"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f11e096d4f5b0af52ec6822f2fba79bd053c083b114f41fcc9ca40112daf5db"
    sha256 cellar: :any_skip_relocation, catalina:       "5828da34c41143336cced7cc8051efd63d525c1a1a4788c6c1235d4bc75cf3df"
    sha256 cellar: :any_skip_relocation, mojave:         "aa994dfc09a72377c001b0f94a0d8674034fe626e2d1a8bba0d6d514e849564b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "61d2b647e77f706f53ef22dcb1ad362d39bed01f2bed08270bc6110824233146"
    sha256 cellar: :any_skip_relocation, sierra:         "8f2cf233141b0ea465c05d3487718176bb40023a05ecf7c275fdae9c36a5eef1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "7e607252679cd1648e6c9f48ebbeaa2379ce089ad87815bd6636e65dcedebc7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1587da7aaa0f1a2617f1a3880601c40a1aa1f342eb5b67fb68bb7c47db896452"
  end

  def install
    system "make"
    bin.install "cidrmerge"
  end

  test do
    input = <<~EOS
      10.1.1.0/24
      10.1.1.1/32
      192.1.4.5/32
      192.1.4.4/32
    EOS
    assert_equal "10.1.1.0/24\n192.1.4.4/31\n", pipe_output("#{bin}/cidrmerge", input)
  end
end
