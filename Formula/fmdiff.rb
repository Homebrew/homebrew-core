class Fmdiff < Formula
  desc "Use FileMerge as a diff command for Subversion and Mercurial"
  homepage "https://github.com/brunodefraine/fmscripts"
  url "https://github.com/brunodefraine/fmscripts/archive/20150915.tar.gz"
  sha256 "45ead0c972aa8ff5b3f9cf1bcefbc069931fd8218b2e28ff76958437a3fabf96"
  license :public_domain
  head "https://github.com/brunodefraine/fmscripts.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "bf75678c84061a3bdcf2c0865bfa87c4453007abf21b3dad875f737ae48922b6" => :big_sur
    sha256 "a49b1ebc974dfdea7865f1a4177f57fd85b64a138ab6273cd825e3739c9517cf" => :arm64_big_sur
    sha256 "4dc5d4eed6916cab57ab1350c7623014c1f2136b69dcb5593c9e344b86328f6c" => :catalina
    sha256 "4c5fb2bb25510c7269a40ef77d55a3d7e52377db2a012d60c3003a9512616314" => :mojave
    sha256 "03bf7b7acda053f3b96de99591fb97cef678297941eab37f52802a3c2734afdd" => :high_sierra
    sha256 "59d9c9d8a8759531a2f715619cfb2bce404fc7378235cf416ea5a426eb8d967f" => :sierra
    sha256 "59d9c9d8a8759531a2f715619cfb2bce404fc7378235cf416ea5a426eb8d967f" => :el_capitan
    sha256 "59d9c9d8a8759531a2f715619cfb2bce404fc7378235cf416ea5a426eb8d967f" => :yosemite
  end

  # Needs FileMerge.app, which is part of Xcode.
  depends_on :xcode

  def install
    system "make"
    system "make", "DESTDIR=#{bin}", "install"
  end

  test do
    ENV.prepend_path "PATH", testpath

    # dummy filemerge script
    (testpath/"filemerge").write <<~EOS
      #!/bin/sh
      echo "it works"
    EOS

    chmod 0744, testpath/"filemerge"
    touch "test"

    assert_match(/it works/, shell_output("#{bin}/fmdiff test test"))
  end
end
