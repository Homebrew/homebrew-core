class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke/archive/v2.8.0.tar.gz"
  sha256 "3539303b864e983e7b8b3e43f83ae9a4900b8361170aac0cd123132f16d4acc4"

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    srcpath = buildpath/"src/github.com/rebuy-de/aws-nuke"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "build"
      bin.install "aws-nuke--darwin-amd64" => "aws-nuke"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "resource-types", shell_output("#{bin}/aws-nuke --help")
  end
end
