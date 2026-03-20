class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "8c1af4a9aebd5334367d5d60c8d56b02755b2027f9f8bc6633b5c3afdc273e1a"
  license "Apache-2.0"
  head "https://github.com/skylot/jadx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "056438b2c1a698a28a6989a8ae959b1374c3830a706b46f79ed3e7bee0f12bf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "056438b2c1a698a28a6989a8ae959b1374c3830a706b46f79ed3e7bee0f12bf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "056438b2c1a698a28a6989a8ae959b1374c3830a706b46f79ed3e7bee0f12bf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "056438b2c1a698a28a6989a8ae959b1374c3830a706b46f79ed3e7bee0f12bf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a2825b8b309e071bed53f619a343dae20959dd2bcc5fe196d62ff2a80b9799a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a2825b8b309e071bed53f619a343dae20959dd2bcc5fe196d62ff2a80b9799a"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV["JADX_VERSION"] = version.to_s if build.stable?

    system "gradle", "clean", "dist"
    libexec.install Dir["build/jadx/*"]
    bin.install libexec/"bin/jadx"
    bin.install libexec/"bin/jadx-gui"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jadx --version")

    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    resource("homebrew-test.apk").stage do
      system bin/"jadx", "-d", "out", "redex-test.apk"
    end
  end
end
