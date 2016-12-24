class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host."
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/ba/a1/b42693985249b537c838ba1226d17179de3d21557f4537b3d9903110096e/mongo-orchestration-0.6.7.tar.gz"
  sha256 "f9086b42f2d0579177f8cc654915e1f77832b21b5569d603bc9fe62b09e61cdb"
  head "https://github.com/10gen/mongo-orchestration"

  bottle do
    cellar :any_skip_relocation
    sha256 "db44ad89fbff4a96578f88526f3c2d26950cfcc68390aefc635a7e02c58f3118" => :sierra
    sha256 "ae0e9bd56ead5a0d9e4844d37c9de685aaca31f3d00ba6dacdc01dcf3551bd7d" => :el_capitan
    sha256 "8af897590e79c7ae67af5f991cc45a6b420abec96a92bc4716f1cd0a38de97db" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/a1/f6/0db23aeeb40c9a7c5d226b1f70ce63822c567178eee5b623bca3e0cc3bef/bottle-0.12.11.tar.gz"
    sha256 "a1958f9725042a9809ebe33d7eadf90d1d563a8bdd6ce5f01849bff7e941a731"
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
