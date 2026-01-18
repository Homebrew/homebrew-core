class Mlogger < Formula
  desc "Log to syslog from the command-line"
  homepage "https://github.com/nbrownus/mlogger"
  url "https://github.com/nbrownus/mlogger/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "141bb9af13a8f0e865c8509ac810c10be4e21f14db5256ef5c7a6731b490bf32"
  license "BSD-4-Clause-UC"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "cc6b446dfb01998bc78128701dfbe10445b0b9433c0f089ada2a04061567e45e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3b373a36ead8caee769bdfd4632f783e948aa3f93605899ba5b08812250f9c69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a33b7e72d83775458e4cdde286cde80c32e30d03d4580f12d74f07db43ded13c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aa5e9292806dcc8150dafdd703720141806be0b610198826e8d226baad776d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2446f830d72176c5dda94e2023f588fea40cb7f0d1fbcce88e07f7ba56cb414"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae9dd6052251a2283883741ec0c1643cf70e62c2acbda9bec06971375b98eced"
    sha256 cellar: :any_skip_relocation, sonoma:         "42d5f8ef829d658a56aefeeb745d09a0629a2dc65fef77782230cb769a76a25f"
    sha256 cellar: :any_skip_relocation, ventura:        "23fb2fbde1f3dcf119ad7d994555dd2920170009a3cf768af1e98b877521f981"
    sha256 cellar: :any_skip_relocation, monterey:       "234b0797fe08d79cd45ee6e2587fafe3322657b70b386e3327f4dc7a103edb3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "251a03f6e4954f46183a2eaa1ead28e993974d1ab5e6b4b6ae85d1777b15a379"
    sha256 cellar: :any_skip_relocation, catalina:       "553fe787f0d6a1982544a74ec268d3db6bdf800d538238cd627ba39d8bb1cc37"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4a8e20b3e717630d8811f612f1808671a08b0e231048d2c014e4b3bc1e4bd424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893dd3f909fe05978eef82de9222ba24cb05e208d73d63f5ef591098df8ceb56"
  end

  def install
    system "make"
    bin.install "mlogger"
  end

  test do
    system bin/"mlogger", "-i", "-d", "test"
  end
end
