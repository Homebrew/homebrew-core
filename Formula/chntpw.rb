class Chntpw < Formula
  desc "Offline NT Password & Registry Editor"
  homepage "https://pogostick.net/~pnh/ntpasswd/"
  url "https://pogostick.net/~pnh/ntpasswd/chntpw-source-140201.zip"
  sha256 "96e20905443e24cba2f21e51162df71dd993a1c02bfa12b1be2d0801a4ee2ccc"
  license "GPL-2.0-only"

  depends_on "openssl@1.1"

  def install
    ENV.append "CFLAGS", "-DUSEOPENSSL"
    ENV.append "CFLAGS", "-I#{Formula["openssl@1.1"].opt_prefix}/include"

    system "make", "chntpw", "cpnt", "reged", "samusrgrp", "sampasswd"
    bin.install "chntpw", "cpnt", "reged", "samusrgrp", "sampasswd"
  end

  test do
    assert_match "chntpw: change password of a user in a Windows SAM file", shell_output("#{bin}/chntpw -h")
  end
end
