class Aoeui < Formula
  desc "Lightweight text editor optimized for Dvorak and QWERTY keyboards"
  homepage "https://code.google.com/archive/p/aoeui/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/aoeui/aoeui-1.6.tgz"
  sha256 "0655c3ca945b75b1204c5f25722ac0a07e89dd44bbf33aca068e918e9ef2a825"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5db4e6bc86d61cb543bba6cfc8f46bb1db2dd51314701866c881c50b09e4aab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d884318d049fd6851389c8c37f7c0eb1042fbeb00c7cf7d0829ce6ab3d45d81d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a151b75fa791fe09b9b8e76783aeb89afdaafef9cd14e70208bde09334dfd84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f595bfa77ba8b7c03b12866673e1104b82d2d9e269c781279010a149ee49597a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1591ca7ff3b44a5947dbe9502987b9eb5566d2670048f3317cdf96d8af28fd77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daa6bd80f0cf479ba65187c2834ce38add2aeb37f93094596dcac9eda5001a68"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa238d9b653cb8eff741c6f9a6811c3e8b9183adce57161a6f4817cfbfbe38b5"
    sha256 cellar: :any_skip_relocation, ventura:        "2e51be697ebb292fbca7958f8f64129d7925929d627911d300fd7e899d0b8feb"
    sha256 cellar: :any_skip_relocation, monterey:       "929a533158d7b0113cefcdfefd36b982eb68da53268a15a37733f737bef2ef79"
    sha256 cellar: :any_skip_relocation, big_sur:        "80411e75607878170abd4516b4ff368d8b4a8d1da0855c540d069d5b4cb88464"
    sha256 cellar: :any_skip_relocation, catalina:       "79a6d037053bc2b3fcd21870ccc274ad02f8e47bde5c9755b8665c25609ddd3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bc5fc0e63ce3c46a6384f860fb44a6ebb0761f9fa4ffdcbe18eb27c27d72180a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b130912a9d91e2462433ad80f02827461c3c6aa8fef646b84cfa0249b9929815"
  end

  uses_from_macos "m4" => :build

  def install
    system "make", "INST_DIR=#{prefix}", "install"
  end
end
