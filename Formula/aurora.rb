class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/xuri/aurora/archive/2.2.tar.gz"
  sha256 "90ac08b7c960aa24ee0c8e60759e398ef205f5b48c2293dd81d9c2f17b24ca42"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "714b7116c80107b6ffb0f5b8abba41ae5aa88708fe688e61144ca3a636b7fc4f" => :big_sur
    sha256 "798b63da7188da92582ffde96fed8f3407add006f2db88a610cb4aacda1c5b89" => :arm64_big_sur
    sha256 "f3b45006b5b5c6f15166d11d1a740fb14f3b22c1d64b3b64397ed2958e9c882d" => :catalina
    sha256 "21abebb582fbac2ebb400328b455c890206f78ae0910f75ded8019bfc6a40c1f" => :mojave
    sha256 "e3e9b06b4b9053afb4b75b48d90555d00fcc8404309d8b2b2b336538810746cb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"aurora"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
