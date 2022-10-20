class Confd < Formula
  desc "Manage local application configuration files using templates"
  homepage "https://github.com/kelseyhightower/confd"
  url "https://github.com/kelseyhightower/confd/archive/v0.16.0.tar.gz"
  sha256 "4a6c4d87fab77aa9827370541024a365aa6b4c8c25a3a9cab52f95ba6b9a97ea"
  license "MIT"
  head "https://github.com/kelseyhightower/confd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "346a9185c6665e85a0b7a810cfdabb1cd397d628a58a40935028a39d3dac6da0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2eb5cdb05b9f92b2472331857765f5b4922183d4cde23e61c44d7bb3d080dfe"
    sha256 cellar: :any_skip_relocation, monterey:       "ba0c1ddd10c298a6283a5d5bcad10304211a68b0d139e27f30c7ef34ae8d2aab"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c337c7afdcf9d7bf7662f94d24fa326990e69344f6c23700ba2a5c0c540592e"
    sha256 cellar: :any_skip_relocation, catalina:       "34d59b3c47493cd00685c62997ac0385f52f90a5d99adb9ed5c98576c6c02452"
    sha256 cellar: :any_skip_relocation, mojave:         "6c83fe2e7e744917d241e8fd51d76b83838ac08dcab31c2663c7b2c7703140cc"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8605d52c611da0530d31178fbb9805592113d70b3d496d21a34696ff499aac70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a67a6ca1953e416e2d1278d6426f8c98e778d829cbff9485d6e12cddd0067b50"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/kelseyhightower/confd").install buildpath.children
    cd "src/github.com/kelseyhightower/confd" do
      system "go", "install", "github.com/kelseyhightower/confd"
      bin.install buildpath/"bin/confd"
    end
  end

  test do
    templatefile = testpath/"templates/test.tmpl"
    templatefile.write <<~EOS
      version = {{getv "/version"}}
    EOS

    conffile = testpath/"conf.d/conf.toml"
    conffile.write <<~EOS
      [template]
      prefix = "/"
      src = "test.tmpl"
      dest = "./test.conf"
      keys = [
          "/version"
      ]
    EOS

    keysfile = testpath/"keys.yaml"
    keysfile.write <<~EOS
      version: v1
    EOS

    system "confd", "-backend", "file", "-file", "keys.yaml", "-onetime", "-confdir=."
    assert_predicate testpath/"test.conf", :exist?
    refute_predicate (testpath/"test.conf").size, :zero?
  end
end
