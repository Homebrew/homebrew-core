class Openvadl < Formula
  desc "Open-source implementation of the VADL processor description language"
  homepage "https://openvadl.org"
  url "https://github.com/OpenVADL/openvadl/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "efe7ce34d97767a84e4e1d8e3f6c13681a0644b719468cd2df53ec5523fbe477"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0", "CC-BY-4.0"]
  head "https://github.com/OpenVADL/openvadl.git", branch: "master"

  depends_on "openjdk@21"

  def install
    system "./gradlew", "--no-daemon", "installDist"
    libexec.install Dir["vadl-cli/build/install/openvadl/*"]
    bin.install_symlink libexec/"bin/openvadl"
  end

  test do
    system bin/"openvadl", "-V"
  end
end
