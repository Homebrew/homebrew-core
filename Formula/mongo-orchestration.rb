class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host."
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/ef/fd/0d4151edb6543db86f27282c872225f2519115fabb2eacd0f8cacea9095c/mongo-orchestration-0.6.8.tar.gz"
  sha256 "ed27f9efa2ca701a3aa221f95c8cec4a6c3b623f82b594aa717d8be76cc15bdc"
  head "https://github.com/10gen/mongo-orchestration"

  bottle do
    cellar :any_skip_relocation
    sha256 "db44ad89fbff4a96578f88526f3c2d26950cfcc68390aefc635a7e02c58f3118" => :sierra
    sha256 "ae0e9bd56ead5a0d9e4844d37c9de685aaca31f3d00ba6dacdc01dcf3551bd7d" => :el_capitan
    sha256 "8af897590e79c7ae67af5f991cc45a6b420abec96a92bc4716f1cd0a38de97db" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/bd/99/04dc59ced52a8261ee0f965a8968717a255ea84a36013e527944dbf3468c/bottle-0.12.13.tar.gz"
    sha256 "39b751aee0b167be8dffb63ca81b735bbf1dd0905b3bc42761efedee8f123355"
  end

  resource "CherryPy" do
    url "https://files.pythonhosted.org/packages/50/c6/6c3d7a3221b0f098f8684037736e5604ea1586a3ba450c4a52b48f5fc2b4/CherryPy-7.0.0.tar.gz"
    sha256 "faead7c5c7ca2526aff8f179a24d699127ed307c3393eeef9610a33b93650bef"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/82/26/f45f95841de5164c48e2e03aff7f0702e22cef2336238d212d8f93e91ea8/pymongo-3.4.0.tar.gz"
    sha256 "d359349c6c9ff9f482805f89e66e476846317dc7b1eea979d7da9c0857ee2721"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  plist_options :startup => true, :manual => "#{HOMEBREW_PREFIX}/opt/mongo-orchestration/bin/mongo-orchestration -b 127.0.0.1 -p 8889 --no-fork start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>mongo-orchestration</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/mongo-orchestration</string>
          <string>-b</string>
          <string>127.0.0.1</string>
          <string>-p</string>
          <string>8889</string>
          <string>--no-fork</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/mongo-orchestration", "-h"
  end
end
