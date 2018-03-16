class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag => "0.11.1",
      :revision => "405641a50b8583dc9fe254b7a22ebc2002722d17"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fc7d8ae503324794a736f0a333a3e8fb1319b21d3a3b240330cfec4eb1758dc" => :high_sierra
    sha256 "0e726f1dac64b0c08c33be268d5ef728687856e99731facb3d99a49181c6c4a5" => :sierra
    sha256 "eb11d04e8ec032d590412ac97cbb383cf4dc56c0131deaa00b5f3cae11a9f094" => :el_capitan
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
