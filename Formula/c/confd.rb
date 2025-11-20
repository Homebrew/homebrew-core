class Confd < Formula
  desc "Manage local application configuration files using templates"
  homepage "https://github.com/kelseyhightower/confd"
  url "https://github.com/kelseyhightower/confd/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "4a6c4d87fab77aa9827370541024a365aa6b4c8c25a3a9cab52f95ba6b9a97ea"
  license "MIT"
  head "https://github.com/kelseyhightower/confd.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e942ea00a80dc2d920a1f6bbee2903b81b82d3a0578e97f46ab169bad181a798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "51310afd5fe23174446bd8cec35b69abf7f13075e1035b714a700f40582d05f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4320090003f15247aa5f860a784bf57f9791b917aab9504f27b576f7b692e028"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99f4686a6b8780c84e9382061d6b1538aab608d6e33e7e208aef6ec39f1f4b79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "346a9185c6665e85a0b7a810cfdabb1cd397d628a58a40935028a39d3dac6da0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2eb5cdb05b9f92b2472331857765f5b4922183d4cde23e61c44d7bb3d080dfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "20ef434c3daa75110a05e2634555a72bc2ffe40a257b151d3f08e1e92dd88547"
    sha256 cellar: :any_skip_relocation, ventura:        "c98a1cbef3ada8032619ae238d2a83b61a743079f06e2a31f436f7e9bd08374f"
    sha256 cellar: :any_skip_relocation, monterey:       "ba0c1ddd10c298a6283a5d5bcad10304211a68b0d139e27f30c7ef34ae8d2aab"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c337c7afdcf9d7bf7662f94d24fa326990e69344f6c23700ba2a5c0c540592e"
    sha256 cellar: :any_skip_relocation, catalina:       "34d59b3c47493cd00685c62997ac0385f52f90a5d99adb9ed5c98576c6c02452"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "844a6849db16075e11b3679e03bfc034b52365c0ef44f341835d80c4fb965617"
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
    conffile.write <<~TOML
      [template]
      prefix = "/"
      src = "test.tmpl"
      dest = "./test.conf"
      keys = [
          "/version"
      ]
    TOML

    keysfile = testpath/"keys.yaml"
    keysfile.write <<~YAML
      version: v1
    YAML

    system bin/"confd", "-backend", "file", "-file", "keys.yaml", "-onetime", "-confdir=."
    assert_path_exists testpath/"test.conf"
    refute_predicate (testpath/"test.conf").size, :zero?
  end
end
