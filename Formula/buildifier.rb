class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag => "0.6.0",
      :revision => "a05406a1a855c6d8ebfc368555ace7638d83c0d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdcd2e18fde049c118a88af8eb43d6d66272eaeeee8aff36793fcf10f9b54bfb" => :high_sierra
    sha256 "762da823bcf541ba683dc3f1e5acd0826d9e5f60ab4647391d8c9bd2c6e27e92" => :sierra
    sha256 "675d34c9762ff453e5059eb0eaa5415756fb5e6b682dd9518ba03be5efe7b94e" => :el_capitan
    sha256 "97700db36b307e06e6ce6f121df6362522d37af102f2c82be4b1c2e79a33b778" => :yosemite
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
