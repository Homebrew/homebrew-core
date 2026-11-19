class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "c2ed4c394d65364447f2c8aa915de42ab9a45e638ec112918efb4c100751e194"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/skylot/jadx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3eaadb1ed17c35dd08c3c454cc2a79bd849cf7b44166c68da926ea893e28e543"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3eaadb1ed17c35dd08c3c454cc2a79bd849cf7b44166c68da926ea893e28e543"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3eaadb1ed17c35dd08c3c454cc2a79bd849cf7b44166c68da926ea893e28e543"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f2dc450cbf7dacdd4e5a9022f25d6f33b29f76de6fa50940b98147938a8cb47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9f2dc450cbf7dacdd4e5a9022f25d6f33b29f76de6fa50940b98147938a8cb47"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  resource "homebrew-test.apk", :test do
    url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
    sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
  end

  def install
    ENV["JADX_VERSION"] = version.to_s if build.stable?

    # `dist` also builds a macOS DMG with a bundled JRE
    system "gradle", "clean", "pack"
    libexec.install Dir["build/jadx/*"]
    bin.install libexec/"bin/jadx"
    bin.install libexec/"bin/jadx-gui"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jadx --version")

    resource("homebrew-test.apk").stage do
      system bin/"jadx", "-d", "out", "redex-test.apk"
    end
  end
end
