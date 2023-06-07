class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/v0.5.0.tar.gz"
  sha256 "a5537cdd9dbcbef8671e3474e249c9fe58d7c9e7c514056e7b3f09a49fed8e2a"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c4b42b7b58e89720fc1ee31101f96abadc978e02d67a05cefbf64609dd9f311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c4b42b7b58e89720fc1ee31101f96abadc978e02d67a05cefbf64609dd9f311"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c4b42b7b58e89720fc1ee31101f96abadc978e02d67a05cefbf64609dd9f311"
    sha256 cellar: :any_skip_relocation, ventura:        "4b92d41153a9d9817e8bd41c4a4566ee6326a36694c622a9c5f02c6da16340c8"
    sha256 cellar: :any_skip_relocation, monterey:       "4b92d41153a9d9817e8bd41c4a4566ee6326a36694c622a9c5f02c6da16340c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b92d41153a9d9817e8bd41c4a4566ee6326a36694c622a9c5f02c6da16340c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5263203511618fc08c31e70a2183f67e9b690dd119945b438ef58cfbbb8c22e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gocloc"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_equal "{\"languages\":[{\"name\":\"C\",\"files\":1,\"code\":4,\"comment\":0," \
                 "\"blank\":0}],\"total\":{\"files\":1,\"code\":4,\"comment\":0,\"blank\":0}}",
                 shell_output("#{bin}/gocloc --output-type=json .")
  end
end
