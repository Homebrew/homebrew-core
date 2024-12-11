class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3850stable.tar.gz"
  version "3.85.0"
  sha256 "a4bde9c8a574363c658e30e72be152bd89a7a227f319ad56d36096abd49df3e5"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9136647d9a8f3ab2fd74eedc4cdccfca6ee6d842836e15ab65bedd9e83df135c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97ab6c5266d32fcdb0cb0dc97bb58fb64a113a559cbd7b256818c9039abb12e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dccd4381ce0a19781558db7769c76ce7bcded21e4f8599f32f53b5a19b8fff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "adc02c786263e06723a55afbcb34739bf29b67ed01f5606d69a6ee5bc729230d"
    sha256 cellar: :any_skip_relocation, ventura:       "3a955aa55cfba10ef2f88e915a5c868a2da4e2af7d09d277aeb5653b3ca34ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc4be4852924c4b49938059c49abb955993a00ce64ceadb5b8ff927a6882d773"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end

  def caveats
    <<~EOS
      To complete the Logtalk installation, define the environment variables:
        LOGTALKHOME=#{HOMEBREW_PREFIX}/share/logtalk
        LOGTALKUSER=$HOME/logtalk
    EOS
  end
end
