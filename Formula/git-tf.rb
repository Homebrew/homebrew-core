class GitTf < Formula
  desc "Share changes between TFS and git"
  homepage "https://archive.codeplex.com/?p=gittf"
  url "https://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.3.20131219.zip"
  sha256 "91fd12e7db19600cc908e59b82104dbfbb0dbfba6fd698804a8330d6103aae74"

  bottle :unneeded

  def install
    libexec.install "git-tf"
    libexec.install "lib"
    (libexec/"native").install "native/macosx"

    bin.write_exec_script libexec/"git-tf"
    doc.install Dir["Git-TF_*", "ThirdPartyNotices*"]
  end

  def caveats; <<~EOS
    This release removes support for TFS 2005 and 2008. Use a previous version if needed.
  EOS
  end

  test do
    system "#{bin}/git-tf"
  end
end
