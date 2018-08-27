class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.4/2.4.2/+download/juju-core_2.4.2.tar.gz"
  sha256 "1c30acb607cf29ffc766ff4a832df2b52addaa6fe1bbc28e2ef94e19533a7e7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bac13976e704a7b69794cc2cd549906b56f556ededbd893595742c05f8312f2" => :mojave
    sha256 "9520ec79d23ae5533f06e7319f7bf8fe06607fb6cb37a0478e12534bfd6c0ea4" => :high_sierra
    sha256 "8b26effd0a3a2e144f1f92600895edd19ebef5188d347adc7882766150b8d390" => :sierra
    sha256 "230a2ca4517187d57f0be41c3894792f6976c01bb0b1863d5444b3c5cd2e6d18" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
