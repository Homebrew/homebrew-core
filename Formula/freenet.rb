class Freenet < Formula
  desc "P2P platform for censorship-resistant communication & publishing"
  homepage "https://freenetproject.org"
  url "https://github.com/freenet/fred/releases/download/build01479/new_installer_offline_1479.jar"
  sha256 "b630cc310987cd225d5250061abb0e72bc19c5ae3b0870c73a979cafea872760"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    (buildpath/"__FreeNetinstall__").write "INSTALL_PATH=#{libexec}"

    system "java", "-jar", "new_installer_offline_#{version}.jar", "-options", "__FreeNetinstall__"

    bin.install_symlink libexec/"run.sh" => "freenet"
  end

  def caveats
    "run wrapper script symlinked to #{bin}/freenet"
  end

  test do
    assert_match "Freenet 0.7 is running", shell_output("#{bin}/freenet status", 0)
  end
end
