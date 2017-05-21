class FlintChecker < Formula
  desc "Check your project for common sources of contributor friction."
  homepage "https://github.com/pengwynn/flint"
  url "https://github.com/pengwynn/flint/archive/v0.1.0.tar.gz"
  sha256 "ec865ec5cad191c7fc9c7c6d5007754372696a708825627383913367f3ef8b7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5aa899806bfdaed0efc45a30e15f102dc53d11d0a20a0f4e335f400bd0eb04a" => :sierra
    sha256 "b515140682a88d55bd78ee83727a52d1b78b3627991acd22f2693de1a581f782" => :el_capitan
    sha256 "88f5110b6a4bd8d7910da4c81968b19d70626c5cf74ea778dea039a4cf78a9fc" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/pengwynn").mkpath
    ln_sf buildpath, buildpath/"src/github.com/pengwynn/flint"
    system "go", "build", "-o", bin/"flint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flint --version", 0)

    shell_output("#{bin}/flint", 2)
    (testpath/"README.md").write("# Readme")
    (testpath/"CONTRIBUTING.md").write("# Contributing Guidelines")
    (testpath/"LICENSE").write("License")
    (testpath/"CHANGELOG").write("changelog")
    (testpath/"CODE_OF_CONDUCT").write("code of conduct")
    (testpath/"script").mkpath
    (testpath/"script/bootstrap").write("Bootstrap Script")
    (testpath/"script/test").write("Test Script")
    shell_output("#{bin}/flint", 0)
  end
end
