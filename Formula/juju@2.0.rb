class JujuAT20 < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.0/2.0.0/+download/juju-core_2.0.0.tar.gz"
  sha256 "dac0b59ac670ba922cfbe7dc29652a07f4166c927c0fdba2f0b5760035b1fe18"

  depends_on "go" => :build
  conflicts_with "juju@1.25", :because => "juju 1 and 2 cannot be installed simultaneously."

  # The juju client wants to know that MacOS Sierra is supported.
  # https://bugs.launchpad.net/juju/+bug/1633495
  patch do
    url "https://raw.githubusercontent.com/sinzui/patches/master/homebrew-juju-sierra.patch"
    sha256 "363bbf23437e07805e0fafd54a758e37ff135c5a529344e53841ae453ad1c39a"
  end

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-2.0"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
