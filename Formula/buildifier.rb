class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag => "0.11.1",
      :revision => "405641a50b8583dc9fe254b7a22ebc2002722d17"

  bottle do
    cellar :any_skip_relocation
    sha256 "a486db453f4b9901d00b57395c3b0a8212e95abc9af08b4e53b2b54c115a4447" => :high_sierra
    sha256 "41977ab25b828d6a155f815eb04b06a705ef35cbe41f430f9b145c4aa1c48c41" => :sierra
    sha256 "af36ea0545473e8811915386c19d278a2be4fcdbdd9f74eaaaf9e87dac2c5821" => :el_capitan
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
