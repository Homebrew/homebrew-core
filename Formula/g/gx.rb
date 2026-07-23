class Gx < Formula
  desc "Language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "2c0b90ddfd3152863f815c35b37e94d027216c6ba1c6653a94b722bf6e2b015d"
  license "MIT"
  head "https://github.com/whyrusleeping/gx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6c57e7d66f64ec58ad228784be3b5a410e830e702ed701debb188b22d7c12177"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2f163d19c275918bb2de9aed07722dda266c010469bcb562bfbd65666d32b64c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54ee0e7162c46736a63a8587f315b69d2090386bac3c46b0da3a9fcbfda5258f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a49ac2040542b71f63e9c30592e102b07fc10561a79b99014773f7c88ffe7c47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1323ff13674b582766dccca83ee63a63314eb3fbc0ccfd815dd9138e073b1f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7099419ae5d6da42d66de65b1a4b9355f586f7484a6a738d1caa1c77ff917670"
    sha256 cellar: :any_skip_relocation, sonoma:         "43a996d21408e29e6b7e4dc7b169f97da742ec8ad4d629cd95a6f43c6cc3c88d"
    sha256 cellar: :any_skip_relocation, ventura:        "e707d45bd29a98762cee6992eccec4b0015c75d6d009488abfafeb96f63684f5"
    sha256 cellar: :any_skip_relocation, monterey:       "800b33c5da09b5165c011858adf22f136390f84c3636a66c32f6114fd9294ea4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5171470b8fe21652a1ae5fef81f0b463a3c10fdac821134f2e8d7635af1ccdda"
    sha256 cellar: :any_skip_relocation, catalina:       "f737f5829c0e1ce2ff58c56515e77f3797c30d614a53ebbf663985d5564c62db"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "55d4271e8778ae0e3ddc5ea048bf985f4972fe928347b04cbc13aaee342c60ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40fe8e9f82a981fbf440651d85215bdc246ef4da138b5378da7318b4f3f04645"
  end

  # project is no longer maintained as people should be
  # expected to use go modules to manage dependencies
  # also see upstream discussion on this, https://github.com/whyrusleeping/gx/issues/247
  deprecate! date: "2024-12-07", because: :unmaintained
  disable! date: "2025-12-07", because: :unmaintained

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "ERROR: no package found in this directory or any above", shell_output("#{bin}/gx deps", 1)
  end
end
