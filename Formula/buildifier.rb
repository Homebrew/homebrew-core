class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "0.17.2",
      :revision => "7926f6cd8f2568556b0efc23530743df4278e0fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "f65e357cd34f1105fc721ceff67b386eb0e83fc7e6c1271cfeb4d0af56ee5435" => :mojave
    sha256 "e92d3cbd94d67add3af2c92c5eba11d7636206803f3ecc13df545c63f3615462" => :high_sierra
    sha256 "72dcd4638b5b093eb1342b53f0429f31eaef8b5213ef3e0c88baf2f0129bf6e8" => :sierra
    sha256 "cda4c2d96781f5c2d03a0d2c27c53ac0ec863a85e483326a0f369095c001e600" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/bazelbuild").mkpath
    ln_sf buildpath, buildpath/"src/github.com/bazelbuild/buildtools"

    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    inreplace "buildifier/buildifier.go" do |s|
      s.gsub! /^(var buildifierVersion = ")redacted/, "\\1#{version}"
      s.gsub! /^(var buildScmRevision = ")redacted/, "\\1#{commit}"
    end

    system "go", "build", "-o", bin/"buildifier", "buildifier/buildifier.go"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
