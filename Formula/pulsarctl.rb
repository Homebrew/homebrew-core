class Pulsarctl < Formula
  desc "CLI for Apache Pulsar written in golang"
  homepage "https://streamnative.io/"
  url "https://github.com/streamnative/pulsarctl.git",
      :tag      => "v0.2.0",
      :revision => "2faa2b8033f51ad8ea3d246fd5effa47263262e2"
  sha256 "d0d6b55017cf349dd893248b0541c8026db9be5d5a7c5523d7bb91426c279fe3"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin / "pulsarctl"
  end

  test do
    out = shell_output("#{bin}/pulsarctl 2>&1")
    assert_match "a CLI for Apache Pulsar", out
  end
end
