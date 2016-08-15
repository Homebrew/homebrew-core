class P2mirror < Formula
  desc "Standalone Mirror Application for P2 (Eclipse) Repositories"
  homepage "https://github.com/rebaze/p2mirror.tool"
  url "https://ci.rebaze.io/nexus/content/repositories/releases/com/rebaze/eclipse/p2mirror/com.rebaze.eclipse.p2mirror.tool/1.1.0.RELEASE/com.rebaze.eclipse.p2mirror.tool-1.1.0.RELEASE-macosx.cocoa.x86_64.tar.gz"
  version "1.1"
  sha256 "39e9ed9ff0bb6218ff2d84c70a640709cd2670545a0831e45fe41d32aecd332c"
  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/p2mirror" => "p2mirror"
    ohai "Usage Artifact Mirror : p2mirror -verbose -application org.eclipse.equinox.p2.metadata.repository.mirrorApplication -source https://bndtools.ci.cloudbees.com/job/bndtools.master/lastSuccessfulBuild/artifact/build/generated/p2 -destination file:/tmp/out"
    ohai "Usage Metadata Mirror : p2mirror -verbose -application org.eclipse.equinox.p2.artifact.repository.mirrorApplication -source https://bndtools.ci.cloudbees.com/job/bndtools.master/lastSuccessfulBuild/artifact/build/generated/p2 -destination file:/tmp/out"
  end

  test do
    ENV.java_cache
    cp_r Dir["#{libexec}/*"], testpath
    assert_match "", shell_output("#{testpath}/Contents/MacOS/p2mirror -application org.eclipse.equinox.p2.metadata.repository.mirrorApplication -source https://bndtools.ci.cloudbees.com/job/bndtools.master/lastSuccessfulBuild/artifact/build/generated/p2 -destination file:#{testpath}/out -configuration #{testpath}/work/config", 0)
    File.exist? testpath/"out/content.jar"
  end
end
