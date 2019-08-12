class ConfluentCli < Formula
  desc "Confluent command-line interface (CLI)"
  homepage "https://docs.confluent.io/current/cli/index.html"
  url "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/latest/confluent_latest_darwin_amd64.tar.gz"
  version "0.141.0"
  sha256 "daf36a696b84c80ecaa7f9f7efd986cd228db778a68aba0b545049d228c229c9"

  bottle :unneeded
  depends_on "confluent-platform"

  def install
    bin.install "confluent"
  end

  def caveats; <<~EOS
    Pass --path /usr/local/bin flag to the command confluent local
    example: confluent --path /usr/local/bin local start
    set environment variable CONFLUENT_HOME to /usr/local/bin
    export CONFLUENT_HOME = /usr/local/bin
  EOS
  end

  test do
    system "#{bin}/confluent", "version"
    assert_match "Confluent CLI", shell_output("#{bin}/confluent version")
  end
end
