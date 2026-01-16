class Cdlabelgen < Formula
  desc "CD/DVD inserts and envelopes"
  homepage "https://www.aczoom.com/tools/cdinsert/"
  url "https://www.aczoom.com/pub/tools/cdlabelgen-4.3.0.tgz"
  sha256 "94202a33bd6b19cc3c1cbf6a8e1779d7c72d8b3b48b96267f97d61ced4e1753f"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.aczoom.com/pub/tools/"
    regex(/href=.*?cdlabelgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b59e22a5f1b438e89d6ae6cc662a70c09c9fd3aeee92538cf6a049296a0ca2be"
  end

  def install
    man1.mkpath
    system "make", "install", "BASE_DIR=#{prefix}"
  end

  test do
    args = %W[
      --category TestTitle
      --cover-template #{pkgshare}/template.ps
      --output-file testout.eps
    ]
    system bin/"cdlabelgen", *args
    assert_path_exists "testout.eps"
  end
end
