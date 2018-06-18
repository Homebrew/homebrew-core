class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag => "0.12.0",
      :revision => "49a6c199e3fbf5d94534b2771868677d3f9c6de9"

  bottle do
    cellar :any_skip_relocation
    sha256 "6986cc5f3b6916e978fad9fb0966494e8b157a327636f9983e0d692c3549fd2f" => :high_sierra
    sha256 "cec72016193f0cae235016106d505e87c1b541d75505cb9fdcb140e6dd7596ac" => :sierra
    sha256 "05fc7dccef827a89a731fd879dfb6a72fcda8c3e3c9a79905653a3ba3240a95c" => :el_capitan
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
