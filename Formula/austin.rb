class Austin < Formula
  desc "Python frame stack sampler for CPython"
  homepage "https://github.com/P403n1x87/austin"
  url "https://github.com/P403n1x87/austin/archive/v3.5.0.tar.gz"
  sha256 "b9cad3670c5f6f750d2c8dc6869a7c5b45fe42305185a0cd3f249e1aa017a7ea"
  license "GPL-3.0-or-later"
  head "https://github.com/P403n1x87/austin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0de09715365ac4597e23b155d11b0b0d99271be864ea94d9c2b15427a23b62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7696560b1ebdd22214bfe43d84bbdb64fbab57be543eecd697a1eb7a8b2aad03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6ab762a326dea05a6edf06473a203abff473157b9dbe5dc72530cce02427119"
    sha256 cellar: :any_skip_relocation, ventura:        "32dfe656fd3d8871a48a60812fa4052734a118e36ed0b81cf2f47aed0b5f3dba"
    sha256 cellar: :any_skip_relocation, monterey:       "377cb1e41106ec9a5ec6d9c47b4bde1a907d29128950c03e6b78c4563fc5448d"
    sha256 cellar: :any_skip_relocation, big_sur:        "22547c81ad04b49404485046b23a59a48a5dd3b393d2d75c5cd6db30d1165b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b53738a65f4e1cd3414e43b1640c5b394a6047f491cb9c6aa598caceb8a4fc8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.11" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
    man1.install "src/austin.1"
  end

  test do
    assert_match "need either a command to run or a PID to attach to",
      shell_output(bin/"austin --gc 2>&1", 255)
    assert_equal "austin #{version}", shell_output(bin/"austin --version").chomp
  end
end
