class GitTf < Formula
  desc "Share changes between TFS and git"
  homepage "https://archive.codeplex.com/?p=gittf"
  url "https://download.microsoft.com/download/A/E/2/AE23B059-5727-445B-91CC-15B7A078A7F4/git-tf-2.0.3.20131219.zip"
  sha256 "91fd12e7db19600cc908e59b82104dbfbb0dbfba6fd698804a8330d6103aae74"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ecaa47f7c8b3e5290ac04f79391446a2e15ec19f9b4e25326d2d2f702f5c7df8"
  end

  deprecate! date: "2021-03-04", because: :unsupported

  depends_on "openjdk"

  def install
    libexec.install "git-tf"
    libexec.install "lib"
    (libexec/"native").install "native/macosx"

    (bin/"git-tf").write_env_script libexec/"git-tf", Language::Java.overridable_java_home_env
    doc.install Dir["Git-TF_*", "ThirdPartyNotices*"]
  end

  def caveats
    <<~EOS
      This release removes support for TFS 2005 and 2008. Use a previous version if needed.
    EOS
  end

  test do
    system "#{bin}/git-tf"
  end
end
