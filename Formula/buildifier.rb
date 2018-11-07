class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "0.17.2",
      :revision => "7926f6cd8f2568556b0efc23530743df4278e0fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3c17f5b5dcc56bea01dbc84796cfaea83fe4bc991a3c4ba301f7a2c74b4975f" => :mojave
    sha256 "9146773b6013b16d689769a97ca35b88f63ebfb905415618ad275569f1470f7a" => :high_sierra
    sha256 "eaae6bfd07289eedced6fec304145d68b297b52440ce4407aaf74a88d2862fe1" => :sierra
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
