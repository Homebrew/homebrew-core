class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_3.5/E.tgz"
  sha256 "918f8c5e91d2b63ee59e4617ad20ca7d052805661335ee271e874ddaf9357ae6"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/"
    regex(%r{href=.*?V?[._-]?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    manifest_sha256 "e0b932fa38aff1912a67cc0a15dd81aac9ac4077d40516f8d58aacb8ef898765"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1cf25b9c8d0e38548b2c4f92c19e6e182bdb2e4b5d6fb04f22c6528735f91188"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f409e72fbac896fc8f64f36dc3e6729f168d99487eff1b93223d80ae06b9824"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "639699bfcdbb32d5de388af9a4f348b593a42bd1770c7a85e21db00c842374a4"
    sha256 cellar: :any,                 arm64_linux:       "07210148a0004a0f947834aaf15de8059f5dbca740c40f0be73d530a9be5fa5b"
    sha256 cellar: :any,                 x86_64_linux:      "58cbfc399eac9dc1e55930e73a4357a7a9174277f04b42700caf5e8bceb5ffdd"
  end

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"eprover", "--help"
  end
end
