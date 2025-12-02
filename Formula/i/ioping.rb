class Ioping < Formula
  desc "Tool to monitor I/O latency in real time"
  homepage "https://github.com/koct9i/ioping"
  url "https://github.com/koct9i/ioping/archive/refs/tags/v1.3.tar.gz"
  sha256 "7aa48e70aaa766bc112dea57ebbe56700626871052380709df3a26f46766e8c8"
  license "GPL-3.0-or-later"
  head "https://github.com/koct9i/ioping.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "89b62c484eb018e00e48c62aa6913d204e5a21d52b24b28906032c13ec278e87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "52741ce205f6edd2660c7848d815fbf708aeecf69439a47984dedd602c0aa783"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f3bda1094884d84cd06efdfdbe955f9926c5e9f265abfcb5ae1169ca03ac73e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "251ce565377d1b3f09d3293c46459b9950b8345ae8e66c2af8e069541880548c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c80c269c2105571ae9ea183372a238c784553652783ea417365010422dd1b2cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3560ce6ce206bb2e7296eca549d45714a945dc001a595dae743f6cb9b3120cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4f39831f232914d0caa0d1f8cac3093d561a7b5daf7016e5778ae9e782d148d"
    sha256 cellar: :any_skip_relocation, ventura:        "808c5aa1e50e89a7a600bf83aa07905c8896be683854ddb7de42ec78c20c26bf"
    sha256 cellar: :any_skip_relocation, monterey:       "b13267eb009500e2ecd3655390e1b39c0083ef38b4cc4945be7a0dfb7fe12746"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca6704be7e6eb5d2e774cebd8afbf125e86f4bf08c9c0ab1140ae283b3bd9cdf"
    sha256 cellar: :any_skip_relocation, catalina:       "6a7926f6e4b0e04d4ba5382f63c3a2434b5744901c26ad865544d887fc888145"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d215c9fae718ae0a3114e38361728c177e3d842db90b61f596d7b835041f3cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e6f04bd51ce45365b256877f1b894023415a07f8966bab528c9eeba9feacb9"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ioping", "-c", "1", testpath
  end
end
