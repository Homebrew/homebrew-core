class ConfluentCli < Formula
  desc "Confluent command line interface (CLI) to administer a development Confluent Platform environment"
  homepage "https://docs.confluent.io/current/cli/index.html"
  url "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/latest/confluent_latest_darwin_amd64.tar.gz"
  version "0.136.0"
  sha256 "91911b121d05298785e1e398260ce6f5b2df5402ee96cbe158cbde4b8f1ebeab"

  bottle :unneeded
  depends_on "confluent-platform"

  def install
    bin.install "confluent"
  end

  test do
    system "#{bin}/confluent", "version"
    assert_match "Confluent CLI", shell_output("#{bin}/confluent version")
  end
end
