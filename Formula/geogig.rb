class Geogig < Formula
  desc "Enable distributed versioning of geospatial data in a git-like context"
  homepage "http://geogig.org"
  url "http://download.locationtech.org/geogig/geogig-1.2.0.zip"
  sha256 "c438d97d8978a9d4985bd4f2ba3fff481b7956bfc4bd986ee3c79c6c07cd4f34"

  bottle :unneeded

  depends_on :java => ["1.8+"]

  def install
    sbin.install "bin/geogig"
    prefix.install "libexec"
    prefix.install "misc"
    (bin/"geogig").write_env_script "#{sbin}/geogig", Language::Java.java_home_env("1.8+")
  end

  test do
    system "#{bin}/geogig", "init"
    system "#{bin}/geogig", "status"
  end
end
