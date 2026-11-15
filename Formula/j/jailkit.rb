class Jailkit < Formula
  desc "Utilities to create limited user accounts in a chroot jail"
  homepage "https://olivier.sessink.nl/jailkit/"
  url "https://olivier.sessink.nl/jailkit/jailkit-2.23.tar.bz2"
  sha256 "aa27dc1b2dbbbfcec2b970731f44ced7079afc973dc066757cea1beb4e8ce59c"
  license all_of: ["BSD-3-Clause", "LGPL-2.0-or-later"]
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?jailkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 5
    sha256 arm64_golden_gate: "d529a63479995c394fb67c4e3714f5ffb2b1e983465068ea1a29fa2ca79d6005"
    sha256 arm64_tahoe:       "ca7605ff12b5dd62ff98cba78d2d62471722a7e42dd3ae849dbd54b242b96ebb"
    sha256 arm64_sequoia:     "bebadf4a159d48a919b8365cf561f41681b77ff3e698d000c1fc38899019f838"
    sha256 arm64_linux:       "8876b9e4aff2060fbed01db3468f61efd6e0937ecd7edb56b30bfe3b8869cee2"
    sha256 x86_64_linux:      "2a9e856b227b87dd22f212788d1959895430547500f6d2a2337f6e7f0a4a3c9a"
  end

  depends_on "python@3.15"

  deny_network_access!

  def install
    ENV["PYTHONINTERPRETER"] = python3

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    jail = testpath/"jail"
    (jail/"etc").mkpath
    (jail/"tmp").mkpath
    chmod 0777, jail/"tmp"
    (testpath/"jk_check.ini").write "[#{jail}]\n"

    output = shell_output("#{sbin}/jk_check -c #{testpath}/jk_check.ini 2>&1")
    assert_match "ERROR: #{jail} is not owned by root:root!", output
    assert_match "WARNING: #{jail}/tmp/ is writable for others!", output
  end
end
